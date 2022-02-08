package sudo.dev.pseudofiles.classes;

import android.content.ContentResolver;
import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;
import android.text.format.Formatter;

import java.util.ArrayList;
import java.util.List;

public class DocumentHelper {

    private static Cursor getCursor(String[] projection, Context context) {
        ContentResolver contentResolver = context.getContentResolver();
        Uri uri = MediaStore.Files.getContentUri("external");
        String selection = null;

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.R) {
            selection = MediaStore.Files.FileColumns.MEDIA_TYPE + "="
                    + MediaStore.Files.FileColumns.MEDIA_TYPE_DOCUMENT;
        } else {
            selection = MediaStore.Files.FileColumns.MEDIA_TYPE + "!="
                    + MediaStore.Files.FileColumns.MEDIA_TYPE_AUDIO + " AND "
                    + MediaStore.Files.FileColumns.MEDIA_TYPE + "!="
                    + MediaStore.Files.FileColumns.MEDIA_TYPE_VIDEO + " AND "
                    + MediaStore.Files.FileColumns.MEDIA_TYPE + "!="
                    + MediaStore.Files.FileColumns.MEDIA_TYPE_PLAYLIST + " AND "
                    + MediaStore.Files.FileColumns.MEDIA_TYPE + "!="
                    + MediaStore.Files.FileColumns.MEDIA_TYPE_IMAGE + " AND "
                    + MediaStore.Files.FileColumns.MEDIA_TYPE + "!="
                    + MediaStore.Files.FileColumns.MEDIA_TYPE_NONE;
        }
        String sortOrder = MediaStore.Files.FileColumns.DATE_MODIFIED + " DESC";
        return contentResolver.query(uri, projection, selection, null, sortOrder);
    }

    public static String getDocumentsSize(Context context) {
        long size = 0L;
        String[] projection = {MediaStore.Files.FileColumns.SIZE};
        Cursor cursor = getCursor(projection, context);
        while (cursor.moveToNext()) {
            size += Long.parseLong(cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.SIZE)));
        }
        return Formatter.formatFileSize(context,size);
    }

    public static List<String> getAllDocuments(Context context) {
        List<String> paths = new ArrayList<>();

        String[] projection = new String[]{MediaStore.Audio.Media.DATA};
        Cursor cursor = getCursor(projection, context);

        while (cursor.moveToNext()) {
            paths.add(cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.DATA)));
        }
        return paths;
    }
}
