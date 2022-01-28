package sudo.dev.pseudofiles.classes;

import android.content.Context;
import android.os.Build;
import android.os.StatFs;
import android.text.format.Formatter;

import androidx.annotation.RequiresApi;
import androidx.core.content.ContextCompat;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.util.HashMap;

public class StorageHelper {
    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
    public HashMap<String, String> getStorageDetails(Context context) {
        StatFs statFs;
        long availableSizeInBytes;
        long totalSizeInBytes;
        HashMap<String, String> storageMap = new HashMap<>();
        File[] files = ContextCompat.getExternalFilesDirs(context, null);
        int index = 1;
        for(File file: files) {
            String[] splitPath = file.getPath().split("/");
            StringBuilder path = new StringBuilder();
            for(String sp: splitPath) {
                if(sp.equals("Android")) break;
                else path.append(sp).append("/");
            }
            statFs = new StatFs(path.toString());
            availableSizeInBytes = statFs.getAvailableBytes();
            totalSizeInBytes = statFs.getTotalBytes();
            storageMap.put("storage_"+ index + "_Available", Formatter.formatShortFileSize(context,availableSizeInBytes));
            storageMap.put("storage_"+ index + "_Total", Formatter.formatShortFileSize(context,totalSizeInBytes));
            index++;
        }
        return storageMap;
    }

    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
    public String getDirectorySize(String path, Context context) {
        File folder = new File(path);
        if (folder.exists() && folder.canRead()){
            try {
                Process p = new ProcessBuilder("du","-c",folder.getAbsolutePath()).start();
                BufferedReader r = new BufferedReader(new InputStreamReader(p.getInputStream()));
                String total = "";
                for (String line; null != (line = r.readLine());)
                    total = line;
                r.close();
                p.waitFor();
                if (total.length() > 0 && total.endsWith("total")) {
                    long directorySize = Long.parseLong(total.split("\\s+")[0]) * 1024;
                    return Formatter.formatFileSize(context, directorySize);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
        return "";
    }
}
