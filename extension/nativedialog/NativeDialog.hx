package extension.nativedialog;

#if android
	#if (openfl < "4.0.0")
	import openfl.utils.JNI;
	#else
	import lime.system.JNI;
	#end
#elseif (ios || blackberry)
import cpp.Lib;
#end

class NativeDialog {

	private static var callbackObject:NativeDialog=null;
	#if android
	private static var __showMessage : String->String->String->Void = JNI.createStaticMethod("nativedialog/NativeDialog", "showMessage", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
	private static var __confirmMessage : String->String->String->String->Void = JNI.createStaticMethod("nativedialog/NativeDialog", "confirmMessage", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
	private static var __enterTextMessage : String->String->String->String->Void = JNI.createStaticMethod("nativedialog/NativeDialog", "enterTextMessage", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V");
	private static var __init : NativeDialog->Void = JNI.createStaticMethod ("nativedialog/NativeDialog", "init", "(Lorg/haxe/lime/HaxeObject;)V");
	#elseif (ios || blackberry)
	/*private static var __showMessage : String->String->String->Void = Lib.load("openflNativeDialogExtension","show_message",3);
	private static var __confirmMessage : String->String->String->String->Void = Lib.load("openflNativeDialogExtension","confirm_message",4);
	private static var __init : Dynamic->Dynamic->Dynamic->Void =  Lib.load ("openflNativeDialogExtension", "set_callback", 3);*/
	#end

	private static function init(){
		if(callbackObject != null) return;
		callbackObject = new NativeDialog();
		#if android
		__init(callbackObject);
		#elseif (ios || blackberry)
		__init(callbackObject._onShowMessageClose, callbackObject._onConfirmMessageOk, callbackObject._onConfirmMessageCancel);
		#end
	}

	public static var onShowMessageClose:Void->Void = null;	
	public static var onConfirmMessageOk:Void->Void = null;
	public static var onConfirmMessageCancel:Void->Void = null;
	public static var onTextEditMessageResult:String->Void = null;

	public static function showMessage(title:String, text:String, buttonText:String) {
		init();
		try{
			#if ( android || ios || blackberry )
				__showMessage(title, text, buttonText);
			#elseif html5
				js.Browser.window.alert(title+"\n"+text);
				callbackObject._onShowMessageClose();
			#end
		}catch(e:Dynamic){
			trace("NativeDialog Exception: "+e);
		}
	}

	public static function confirmMessage(title:String, text:String, okButtonText:String, cancelButtonText:String) {
		init();
		try{
			#if ( android || ios || blackberry )
				__confirmMessage(title, text, okButtonText, cancelButtonText);
			#elseif html5
				if(js.Browser.window.confirm(title+"\n"+text)){
					callbackObject._onConfirmMessageOk();
				}else{
					callbackObject._onConfirmMessageCancel();
				}
			#end
		}catch(e:Dynamic){
			trace("NativeDialog Exception: "+e);
		}
	}	
	
	public static function enterTextMessage(title:String, description:String, okButtonText:String, defaultText:String) {
		init();
		try{
			#if ( android )
				__enterTextMessage(title, description, okButtonText, defaultText);			
			#end
		}catch(e:Dynamic){
			trace("NativeDialog Exception: "+e);
		}
	}

	/////////////////////////// EVENT HANDLING ////////////////////////////

	private function new() {}
	private function _onShowMessageClose() { if(onShowMessageClose!=null) onShowMessageClose(); }
	private function _onConfirmMessageOk() { if(onConfirmMessageOk!=null) onConfirmMessageOk(); }
	private function _onConfirmMessageCancel() { if(onConfirmMessageCancel!=null) onConfirmMessageCancel(); }
	private function _onTextEditMessageResult( result:String ) { if (onTextEditMessageResult != null) onTextEditMessageResult(result); }
	
}
