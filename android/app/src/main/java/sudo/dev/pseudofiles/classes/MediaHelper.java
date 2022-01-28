package sudo.dev.pseudofiles.classes;

import android.annotation.SuppressLint;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.provider.MediaStore;

import java.io.File;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

public class MediaHelper {
    private final Context context;
    private final MediaType type;

    public MediaHelper(Context context, String type) {
        this.context = context;
        this.type = MediaType.valueOf(type);
    }

    public MediaHelper(Context context) {
        this.context = context;
        this.type = MediaType.image;
    }

    public List<String> getRecentFiles(int limit) {
        List<String> paths = new ArrayList<>();
        Uri uri = MediaStore.Files.getContentUri("external");
        String[] projection = {MediaStore.Files.FileColumns.DATA};
        String selection = MediaStore.Files.FileColumns.MEDIA_TYPE + "!="
                + MediaStore.Files.FileColumns.MEDIA_TYPE_PLAYLIST;
        String sortOrder = MediaStore.Files.FileColumns.DATE_MODIFIED + " DESC";

        Cursor cursor = context.getContentResolver().query(uri, projection, selection, null, sortOrder);

        if(limit != -1) {
            cursor.moveToFirst();
            for(int i=0; i<limit; i++) {
                paths.add(cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Files.FileColumns.DATA)));
                cursor.moveToNext();
            }
        } else {
            while (cursor.moveToNext()) {
                paths.add(cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Files.FileColumns.DATA)));
            }
        }

        return paths;
    }

    public Cursor getCursor(String[] projection) {
        Uri uri;
        //String sortOrder = MediaStore.Files.FileColumns.DATE_ADDED + " ASC";

        switch (type) {
            case audio:{
                uri = MediaStore.Audio.Media.EXTERNAL_CONTENT_URI;
                if(projection == null) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                        projection = new String[]{
                                MediaStore.Audio.Media.DATA,
                                MediaStore.Audio.Media.BUCKET_DISPLAY_NAME
                        };
                    } else {
                        projection = new String[]{MediaStore.Audio.Media.DATA};
                    }
                }
                break;
            }
            case image:{
                uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
                if(projection == null) {
                    projection = new String[]{
                            MediaStore.Images.Media.DATA,
                            MediaStore.Images.Media.BUCKET_DISPLAY_NAME,
                    };
                }
                break;
            }
            case video:{
                uri = MediaStore.Video.Media.EXTERNAL_CONTENT_URI;
                if(projection == null) {
                    projection = new String[]{
                            MediaStore.Video.Media.DATA,
                            MediaStore.Video.Media.BUCKET_DISPLAY_NAME,
                    };
                }
                break;
            }
            default: uri = MediaStore.Images.Media.EXTERNAL_CONTENT_URI;
        }

        final String orderBy = MediaStore.Files.FileColumns.DATE_ADDED;
        return context.getContentResolver().query(uri, projection, null, null, orderBy + " DESC");
    }

    public Long getMediaSize() {
        long size = 0L;
        //String[] projection = isImage ? new String[]{MediaStore.Images.Media.SIZE} : new String[]{MediaStore.Video.Media.SIZE};
        String[] projection = {MediaStore.Files.FileColumns.SIZE};
        Cursor cursor = getCursor(projection);
        while (cursor.moveToNext()) {
            size += Long.parseLong(cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.SIZE)));
        }
        return size;
    }

    @SuppressLint("InlinedApi")
    public List<HashMap<String, List<String>>> getMediaPaths() {
        ArrayList<MediaModel> allImages = new ArrayList<>();
        List<HashMap<String, List<String>>> imagesMap = new ArrayList<>();
        List<String> folderNames = new ArrayList<>();

        String absolutePathOfImage = null;
        Cursor cursor = getCursor(null);

        while (cursor.moveToNext()) {
            absolutePathOfImage = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.DATA));
            String folderName;
            if (android.os.Build.VERSION.SDK_INT <= android.os.Build.VERSION_CODES.Q && type == MediaType.audio) {
                String[] splitPath = absolutePathOfImage.split("/");
                folderName = splitPath[splitPath.length - 2];
            } else {
                folderName = cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.BUCKET_DISPLAY_NAME));
            }
            if(folderName == null) {
                folderName = "Root";
            }

            if(!folderNames.contains(folderName)) {
                folderNames.add(folderName);
            }

            MediaModel objModel = new MediaModel();
            objModel.setFolderName(folderName);
            objModel.setMediaPath(absolutePathOfImage);

            allImages.add(objModel);
        }

        File file = new File(allImages.get(0).getMediaPath());
        System.out.println(Uri.fromFile(file));

        String folderName;
        HashMap<String, List<String>> imageFolders;
        ArrayList<MediaModel> selectedImages;

        for(String fName: folderNames) {
            selectedImages = new ArrayList<>();
            List<String> mediaPaths = new ArrayList<>();
            for (int i = 0; i < allImages.size(); i++) {
                folderName = allImages.get(i).getFolderName();
                if(folderName == null) {
                    folderName = "Root";
                }
                if (folderName.equals(fName)) {
                    mediaPaths.add(allImages.get(i).getMediaPath());
                    selectedImages.add(allImages.get(i));
                }
            }
            imageFolders = new HashMap<>();
            imageFolders.put(fName, mediaPaths);
            imagesMap.add(imageFolders);
            allImages.removeAll(selectedImages);
        }

        return imagesMap;
    }
}
