package sudo.dev.pseudofiles.classes;

import android.app.AppOpsManager;
import android.app.usage.StorageStats;
import android.app.usage.StorageStatsManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.UserHandle;
import android.os.storage.StorageManager;
import android.os.storage.StorageVolume;
import android.provider.MediaStore;
import android.provider.Settings;
import android.text.format.Formatter;
import android.util.Log;

import androidx.annotation.RequiresApi;
import androidx.core.content.res.ResourcesCompat;

import com.google.gson.Gson;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.UUID;

public class ApplicationHelper {
    private final Context context;

    public ApplicationHelper(Context context) {
        this.context = context;
    }

    @RequiresApi(api = Build.VERSION_CODES.LOLLIPOP)
    void checkAndGrantUsagePermission() {
        AppOpsManager appOps = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
        int mode = appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), context.getPackageName());
        boolean granted = (mode == AppOpsManager.MODE_ALLOWED);
        if(!granted) {
            Intent intent = new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS);
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(intent);
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public String getInstalledAppSizes() {
        /**
         * Need to add the following intent when launching the app for the first time for the app to correctly fetch app size;
         *
         * Intent intent = new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS);
         * intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
         * context.startActivity(intent);
         **/
        checkAndGrantUsagePermission();

        PackageManager packageManager = context.getPackageManager();
        List<ApplicationInfo> packages = packageManager.getInstalledApplications(PackageManager.GET_META_DATA);
        long size = 0L;
        for(ApplicationInfo applicationInfo: packages) {
            final StorageStatsManager storageStatsManager = (StorageStatsManager) context.getSystemService(Context.STORAGE_STATS_SERVICE);
            final StorageManager storageManager = (StorageManager) context.getSystemService(Context.STORAGE_SERVICE);
            final List<StorageVolume> storageVolumes = storageManager.getStorageVolumes();
            final UserHandle user = android.os.Process.myUserHandle();
            final String uuidStr = storageVolumes.get(0).getUuid();
            final UUID uuid = uuidStr == null ? StorageManager.UUID_DEFAULT : UUID.fromString(uuidStr);
            try {
//                Log.d("AppLog", "storage:" + uuid + " : " + storageVolumes.get(0).getDescription(context) + " : " + storageVolumes.get(0).getState());
//                Log.d("AppLog", "getFreeBytes:" + Formatter.formatShortFileSize(context, storageStatsManager.getFreeBytes(uuid)));
//                Log.d("AppLog", "getTotalBytes:" + Formatter.formatShortFileSize(context, storageStatsManager.getTotalBytes(uuid)));
//                Log.d("AppLog", "storage stats for app of package name:" + applicationInfo.packageName + " : ");

                final StorageStats storageStats = storageStatsManager.queryStatsForPackage(uuid, applicationInfo.packageName, user);
                size += storageStats.getAppBytes() + storageStats.getCacheBytes() + storageStats.getDataBytes();
//                Log.d("AppLog", "getAppBytes:" + Formatter.formatShortFileSize(context, storageStats.getAppBytes()) +
//                        " getCacheBytes:" + Formatter.formatShortFileSize(context, storageStats.getCacheBytes()) +
//                        " getDataBytes:" + Formatter.formatShortFileSize(context, storageStats.getDataBytes()));
            } catch (PackageManager.NameNotFoundException e) {
                e.printStackTrace();
            } catch (IOException e) {
                e.printStackTrace();
            }
//            for (StorageVolume storageVolume : storageVolumes) {
//
//            }
        }
        return Formatter.formatFileSize(context, size);
    }

    public List<String> getApkFromStorage() {
        List<String> paths = new ArrayList<>();
        String mimeType = "application/vnd.android.package-archive";
        String whereClause = MediaStore.Files.FileColumns.MIME_TYPE + " IN ('" + mimeType + "')";
        String orderBy = MediaStore.Files.FileColumns.SIZE + " DESC";
        Cursor cursor = context.getContentResolver().query(MediaStore.Files.getContentUri("external"),
                null,
                whereClause,
                null,
                orderBy);
        if (cursor.moveToFirst()) {
            do {
                paths.add(cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Files.FileColumns.DATA)));
            } while (cursor.moveToNext());
        }
        return paths;
    }

    public List<HashMap<String, Object>> getInstalledApps() {
        final PackageManager packageManager = context.getPackageManager();
        List<ApplicationInfo> packages = packageManager.getInstalledApplications(PackageManager.GET_META_DATA);
        HashMap<String, Object> apps;
        List<HashMap<String, Object>> installedApps = new ArrayList<>();
        PackageInfo packageInfo = new PackageInfo();

        for (ApplicationInfo applicationInfo : packages) {
            if(packageManager.getLaunchIntentForPackage(applicationInfo.packageName) != null) {
                if (0 == (applicationInfo.flags & (ApplicationInfo.FLAG_UPDATED_SYSTEM_APP | ApplicationInfo.FLAG_SYSTEM))) {
                    try {
                        packageInfo = packageManager.getPackageInfo(applicationInfo.packageName, 0);
                    } catch (PackageManager.NameNotFoundException e) {
                        e.printStackTrace();
                    }
                    apps = getAppInfo(applicationInfo, packageInfo, context);
                    installedApps.add(apps);
                }
            }
        }
        return installedApps;
    }

    public HashMap<String, Object> getApkDetails(String path) {
        HashMap<String, Object> appInfo = new HashMap<>();
        final PackageManager packageManager = context.getPackageManager();
        PackageInfo packageInfo = packageManager.getPackageArchiveInfo(path, PackageManager.GET_PERMISSIONS);
        if(packageInfo != null) {
            packageInfo.applicationInfo.sourceDir = path;
            packageInfo.applicationInfo.publicSourceDir = path;
            appInfo = getAppInfo(packageInfo.applicationInfo, packageInfo, context);
        }
        return appInfo;
    }

    public HashMap<String, Object> getAppInfo(ApplicationInfo applicationInfo, PackageInfo packageInfo, Context context) {
        HashMap<String, Object> app;
        PackageManager packageManager = context.getPackageManager();
        Gson gson = new Gson();
        byte[] appIcon = new byte[0];
        Drawable icon = applicationInfo.loadIcon(packageManager);
        //Drawable icon = packageManager.getApplicationIcon(applicationInfo.packageName);
        if(icon != null) {
            appIcon = getImageAsByteArray(drawableToBitmap(icon));
        } else {
            System.out.println("here");
            Bitmap bitmap = null;
            try {
                bitmap = BitmapFactory.decodeResource(packageManager.getResourcesForApplication(applicationInfo),
                        packageInfo.applicationInfo.icon);
                if(bitmap != null) {
                    appIcon = getImageAsByteArray(bitmap);
                } else {
                    try {
                        Drawable iconNew = ResourcesCompat.getDrawable(packageManager.getResourcesForApplication(applicationInfo),
                                packageInfo.applicationInfo.icon, null);
                        if(iconNew != null) {
                            appIcon = getImageAsByteArray(drawableToBitmap(iconNew));
                        }
                    } catch (Exception ex) {
                        ex.printStackTrace();
                    }
                }
            } catch (PackageManager.NameNotFoundException nameNotFoundException) {
                nameNotFoundException.printStackTrace();
            }
        }
        //Drawable icon = packageManager.getActivityIcon(packageManager.getLaunchIntentForPackage(applicationInfo.packageName));
        String label = packageManager.getApplicationLabel(applicationInfo).toString();

        app = new HashMap<>();
        app.put("icon", appIcon);
        app.put("label", label);
        app.put("installedDate", packageInfo.firstInstallTime);
        app.put("modifiedDate", packageInfo.lastUpdateTime);
        app.put("version", packageInfo.versionName);
        app.put("packageName", packageInfo.packageName);
        return app;
    }

    public static Bitmap drawableToBitmap(Drawable drawable) {
        if (drawable instanceof BitmapDrawable) {
            return ((BitmapDrawable) drawable).getBitmap();
        }

        final int width = !drawable.getBounds().isEmpty() ? drawable
                .getBounds().width() : drawable.getIntrinsicWidth();

        final int height = !drawable.getBounds().isEmpty() ? drawable
                .getBounds().height() : drawable.getIntrinsicHeight();

        final Bitmap bitmap = Bitmap.createBitmap(width <= 0 ? 1 : width,
                height <= 0 ? 1 : height, Bitmap.Config.ARGB_8888);

        Canvas canvas = new Canvas(bitmap);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);

        return bitmap;
    }

    byte[] getImageAsByteArray(Bitmap bitmap) {
        if(bitmap == null) {
            return new byte[0];
        }
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
        return stream.toByteArray();
    }
}
