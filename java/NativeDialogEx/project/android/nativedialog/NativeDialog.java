package nativedialog;

import android.content.DialogInterface;
import android.app.AlertDialog;
import android.text.InputType;
import android.widget.EditText;
import android.widget.TextView.BufferType;
import org.haxe.lime.GameActivity;
import org.haxe.lime.HaxeObject;
import org.haxe.extension.Extension;

public class NativeDialog {

	private static HaxeObject callback = null;

	public static void init( HaxeObject callback ) {
		NativeDialog.callback = callback;
	}
    
	public static void showMessage( final String title, final String text, final String buttonText) {
		Extension.mainActivity.runOnUiThread(new Runnable() {
			public void run() {
				AlertDialog.Builder dialog = new AlertDialog.Builder(Extension.mainContext);
				DialogInterface.OnClickListener onClickListener = new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						if(NativeDialog.callback!=null) NativeDialog.callback.call ("_onShowMessageClose",null);
					}
				};
				dialog.setTitle(title);
				dialog.setMessage(text);
				dialog.setNeutralButton(buttonText, onClickListener);
				dialog.setCancelable(false);
				dialog.show();
			}
		});
	}

	public static void confirmMessage( final String title, final String text, final String okText, final String cancelText) {
		Extension.mainActivity.runOnUiThread(new Runnable() {
			public void run() {
				AlertDialog.Builder dialog = new AlertDialog.Builder(Extension.mainContext);
				DialogInterface.OnClickListener onClickListener = new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						if(NativeDialog.callback==null) return;
						if(which == DialogInterface.BUTTON_POSITIVE) NativeDialog.callback.call ("_onConfirmMessageOk",null);						
						if(which == DialogInterface.BUTTON_NEGATIVE) NativeDialog.callback.call ("_onConfirmMessageCancel",null);						
					}
				};
				dialog.setTitle(title);
				dialog.setMessage(text);
				dialog.setPositiveButton(okText, onClickListener);
				dialog.setNegativeButton(cancelText, onClickListener);
				dialog.setCancelable(false);
				dialog.show();
			}
		});		
	}

	public static void enterTextMessage( final String title, final String description, final String okText, final String defaultText ) {
		Extension.mainActivity.runOnUiThread(new Runnable() {
			public void run() {
				AlertDialog.Builder dialog = new AlertDialog.Builder(Extension.mainContext);
				final EditText input = new EditText(Extension.mainContext);	
				if ( defaultText != null ){
					input.setText(defaultText, BufferType.EDITABLE );
				}
				input.setInputType(InputType.TYPE_CLASS_TEXT /*| InputType.TYPE_TEXT_FLAG_AUTO_COMPLETE /*| InputType.TYPE_TEXT_VARIATION_PASSWORD*/);// Specify the type of input expected; this, for example, sets the input as a password, and will mask the text
								
				DialogInterface.OnClickListener onClickListener = new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						if(NativeDialog.callback==null) return;
						if(which == DialogInterface.BUTTON_POSITIVE) NativeDialog.callback.call ("_onTextEditMessageResult", new Object[] { input.getText().toString() } );
						if(NativeDialog.callback!=null) NativeDialog.callback.call ("_onShowMessageClose",null);
					}
				};
				dialog.setTitle(title);
				if ( description != null ){
					dialog.setMessage(description);				
				}
				dialog.setView(input);
				dialog.setPositiveButton(okText, onClickListener);
				dialog.setCancelable(true);
				dialog.show();
			}
		});		
	}
}
