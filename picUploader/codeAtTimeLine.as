import flash.external.ExternalInterface;
import flash.events.Event;

Security.allowDomain("*");

var file:FileReference;
var imgfilter:FileFilter;
var isSelect:Boolean;
var isBusy:Boolean;

var submitUrl:String = "http://pl.7k7k.com/comment.php?cmd=upload";
var maxSize:Number = 5 * 1024 * 1024;
var guid:String;
var userPars:Object = root.loaderInfo.parameters;
guid = userPars["gid"] || Math.random().toString();
maxSize = Number(userPars["size"]) || maxSize;

this.addEventListener(Event.ENTER_FRAME,checkFrame);
function checkFrame(e:Event) {
	if (stage.stageWidth!=0&&stage.stageHeight!=0) {
		this.removeEventListener(Event.ENTER_FRAME,checkFrame);
		this.startApp();
		callJs("onReady", null);
	}
}

function startApp():void{
	//
	addApi();
	
	file = new FileReference();
	imgfilter=new FileFilter("Image","*.png;*.jpg;*.gif;");
	file.addEventListener(Event.COMPLETE, onComplete);
	file.addEventListener(Event.OPEN, onOpen);
	file.addEventListener(Event.SELECT, onSelect);
	file.addEventListener(Event.CANCEL, onCancel);
	file.addEventListener(ProgressEvent.PROGRESS, onProgress);
	file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadCompleteDataHandler);
	file.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
	file.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	browseBnt.addEventListener(MouseEvent.CLICK, doSelectFile);
}

function ioErrorHandler(e:IOErrorEvent):void {
	onError(-3);
}

function securityErrorHandler(e:SecurityErrorEvent):void {
	onError(-4);
}


function onOpen(e:Event):void {
	callJs("onOpen", null);
}

function onCancel(e:MouseEvent):void {
	callJs("onCancel", null)
}

function onProgress(e:ProgressEvent) {
	callJs("onProgress", Math.floor(e.bytesLoaded/e.bytesTotal*100));
}

function onComplete(e:Event):void {
	callJs("onComplete", 'test');
}

function uploadCompleteDataHandler(event:DataEvent):void {
	callJs("onComplete", event.data);
}

function onSelect(e:Event):void {
	var file:FileReference = FileReference(e.target);
	if (file.size <= maxSize) {
		isSelect = true;
		callJs("onSelect", file);
	} else {
		onError(-2);
	}
}

function onError(code:Number):void {
	isBusy = false;
	callJs("onError", code);
}


function doCancel():void {
	file.cancel();
	isSelect = false;
	isBusy = false;
}

function doReset():void {
	isSelect = false;
	isBusy = false;
}

function doSelectFile(e:MouseEvent):void {
	file.browse([imgfilter]);
}

function doUploadFile(url:*):void {
	if (isBusy) {
		onError(-5);
	} else {
		if (isSelect) {
			isBusy = true;
			callJs("onStart", null);
			var u = String(url);
			if (u === null || u === undefined || u === "") u = submitUrl;
			try {
				file.upload(new URLRequest(u));
			} catch(e:Error) {
				onError(-6);
			}
		} else {
			onError(-1);
		}
	}
}

function callJs(method:String, pars:Object):void {
	if (ExternalInterface.available && userPars[method] !== null && userPars[method] !== undefined && userPars[method] !== "") {
		ExternalInterface.call(userPars[method], guid, pars);
	}
}

function addApi():void {
	if (ExternalInterface.available) {
		ExternalInterface.addCallback("submit", doUploadFile);
		ExternalInterface.addCallback("reset", doReset);
		ExternalInterface.addCallback("cancel", doCancel);
	}
}