package sudo.dev.pseudofiles.classes;

import android.content.Context;
import android.database.Cursor;
import android.net.Uri;
import android.provider.MediaStore;

import java.util.ArrayList;
import java.util.List;

public class SearchHelper {
    public static List<String> getSearchedFiles(String fileName, Context context) {
        List<String> paths = new ArrayList<>();
        Uri uri = MediaStore.Files.getContentUri("external");
        String[] projection = {MediaStore.Files.FileColumns.DATA};
        String sortOrder = MediaStore.Files.FileColumns.DATE_MODIFIED + " DESC";
        Cursor cursor = context.getContentResolver().query(uri, projection, MediaStore.Files.FileColumns.DATA + " like ? ",
                new String[] {"%" + fileName + "%"}, sortOrder);
        while (cursor.moveToNext()) {
            paths.add(cursor.getString(cursor.getColumnIndexOrThrow(MediaStore.Files.FileColumns.DATA)));
        }
        return paths;
    }
}
