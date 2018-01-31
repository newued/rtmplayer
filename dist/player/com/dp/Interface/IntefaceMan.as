package com.dp.Interface {
	import flash.external.*
		import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.system.System;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import com.dp.Interface.MyTextFormat;
	import flash.events.MouseEvent;
	import com.dp.Custom.FlashVarsEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;

	public class IntefaceMan extends Sprite {
		public var _flashVars: Object = {
			video:[],
			lv: 0, //0普通形式 1=直播形式 默认是0 ，直播时播放器的进度条将被锁定/隐藏。显示时间的文本内容也显示为= 已播放时长：05：14
			wh: '16:9', //默认比例  
			v: 0.8, //默认音量   
			c: 1, //默认清晰度   0标清,1高清,2超清
			tm: false, //默认是否开启设置弹幕  默认true是开启 false不开启
			configtm: {
				'font': '苹方 细体',
				'size': '12',
				'color': '0xff6e26',
				'position': '1'
			}, //默认弹幕设置 (position: 0顶部 1中间  2底部）
			tmdefault: '你好', //默认tm幕
			subtitles:new Array(), //设置字幕[{'BeginTime':t,'EndTime':d，'Text':'sdfewfewfewgwgew'}]
			dots: new Array(), //默认打点列表[{'Time':80,'DotText':'我是打点文字'}]
			light: true, //开关灯 默认true开  false关,
			p: 0, //默认自动播放 数值 0 默认不自动播放 1加载后播放 2 默认播放 	//初始化后不可修改
			h: 0, //是否支持随意拖动进度条 默认支持 1为不支持  			    	//初始化后不可修改
			start: 0, //默认从指定时间点开始播放 								//初始化后不可修改
			thumbtime: 3 //设置缩略图多久产生一个 单位秒 默认3秒, 				//初始化后不可修改
		};
		private var _root: MovieClip;
		public function IntefaceMan(_value: MovieClip) {
			_root = _value;
			if(ExternalInterface.available) {
				try {
					var containerReady: Boolean = isContainerReady();
					if(containerReady) {
						setupCallbacks();
					} else {
						var readyTimer: Timer = new Timer(200);
						readyTimer.addEventListener(TimerEvent.TIMER, timerHandler);
						readyTimer.start();
					}
				} catch(err) {
					trace("External interface is not available for this container.");
				}
			}
		}

		private function timerHandler(event: TimerEvent): void {
			var isReady: Boolean = isContainerReady();
			if(isReady) {
				Timer(event.target).stop();
				setupCallbacks();
			}
		}
		//检测外部容器是否可用
		public function isContainerReady(): Boolean {
			var result: Boolean = ExternalInterface.call("isReady");
			return result;
		}
		private function setupCallbacks() {
			_flashVars = _root.loaderInfo.parameters;
			for(var i in _flashVars) {
				if(i == "configtm" && (_flashVars["configtm"].indexOf('@') > -1)) {
					var configtmArr: Array = _flashVars["configtm"].split("@"); //
					var _MyTextFormat: MyTextFormat = new MyTextFormat();
					_MyTextFormat.size = configtmArr[2] * 4 + 8;
					_MyTextFormat.color = configtmArr[4] == "1" ? 0x990033 : (configtmArr[4] == "2" ? 0x333333 : 0xff6e26); //跟舞台上对象要保持统一
					ExternalInterface.call("consolesome", configtmArr[4] == "1" ? 0x990033 : (configtmArr[4] == "2" ? 0x333333 : 0xff6e26));
					_MyTextFormat.font = "苹方 细体";
					_MyTextFormat.position = configtmArr[6];
					_flashVars[i] = _MyTextFormat;
				} else if(i == "dots") {
					var dotsArr: Array = _flashVars["dots"].split("@"); //
					_flashVars["dots"] = [];
					for(var d: int = 1; d < dotsArr.length; d++) {
						if(d % 2 == 0) {
							_flashVars["dots"].push({"Time":parseInt(dotsArr[d-1]),"DotText":dotsArr[d]});
						}
					}
				} else if(i == "video") {
					var videosArr: Array = _flashVars["video"].split("@"); //
					_flashVars["video"] = [];
					for(var v: int = 1; v < videosArr.length; v++) {
						if(v%2==0){
							_flashVars["video"].push([videosArr[v-1],videosArr[v]]);	
							}		
						}
					} else if(i == "subtitles") {
					var subtitlesArr: Array = _flashVars["subtitles"].split("@"); //
					_flashVars["subtitles"] = [];
					for(var t: int = 1; t < subtitlesArr.length; t++) {
						if(t%3==0){
							_flashVars["subtitles"].push({"BeginTime":parseInt(subtitlesArr[t-2]),"EndTime":parseInt(subtitlesArr[t-1]),"Text":subtitlesArr[t]});	
							}		
						}
					}
			}
			ExternalInterface.call("setSWFIsReady");
			ExternalInterface.addCallback("getiNowTime", getiNowTime);
			ExternalInterface.addCallback("getLight", getLight);
			ExternalInterface.addCallback("getTmDefault", getTmDefault);
			ExternalInterface.addCallback("getDots", getDots);
			ExternalInterface.addCallback("getSeeTimes", getSeeTimes);
			ExternalInterface.addCallback("getFullStatu", getFullStatu);
			ExternalInterface.addCallback("getPlayStatu", getPlayStatu);
			ExternalInterface.addCallback("getVolume", getVolume);
			ExternalInterface.addCallback("play2", play2);
			ExternalInterface.addCallback("pause2", pause2);
			ExternalInterface.addCallback("seek2", seek2);
			ExternalInterface.addCallback("changeFlashVars", changeFlashVars);
		}
		public function changeFlashVars(argobj: Object) {
			for(var i in argobj) {
				if(i == "configtm" && (typeof(argobj[i]) != "object")) {
					var configtmArr: Array = argobj["configtm"].split("@"); //
					var _MyTextFormat: Object = {};
					_MyTextFormat.size = (parseInt(configtmArr[2]) < 4) ? configtmArr[2] * 4 + 8 : configtmArr[2] + 0;
					if(parseInt(configtmArr[4]) < 4) {
						_MyTextFormat.color = configtmArr[4] == "1" ? 0x990033 : (configtmArr[4] == "2" ? 0x333333 : 0xff6e26); //跟舞台上对象要保持统一
					}
					_MyTextFormat.font = "苹方 细体";
					_MyTextFormat.position = configtmArr[6];
					_flashVars[i] = _MyTextFormat;
				} else if(i == "dots" && (typeof(argobj[i]) == "object")) {
					var obj: Object = {
						"Time": argobj[i].Time,
						"DotText": argobj[i].DotText
					}
					_flashVars['dots'].push(obj);
					_flashVars['dots'].sortOn('Time', Array.NUMERIC); //对打点列表进行时间排序
					for(var o: int = 0; o < _flashVars['dots'].length; o++) {
						ExternalInterface.call("consolesome", " ||dot" + o + ":" + _flashVars['dots'][o]["Time"] + " " + _flashVars['dots'][o]["DotText"]);
					}
				} else {
					_flashVars[i] = argobj[i];
				}
				ExternalInterface.call("consolesome","||"+i+"_change"+"||"+i+"||"+_flashVars[i]+(i.toString())+_flashVars[i]);
				var senderContent:Object={(i.toString()):_flashVars[i]};
				
				_root.swfDispatch(new FlashVarsEvent(i+"_change",senderContent, "js"));
			}
		}
		public function selfchangeFlashVars(argobj: Object, _sender: String) {
			for(var i in argobj) {
				if(i == "configtm" && (typeof(argobj[i]) != "object")) {
					var configtmArr: Array = argobj["configtm"].split("@"); //
					var _MyTextFormat: Object = {};
					_MyTextFormat.size = (parseInt(configtmArr[2]) < 4) ? configtmArr[2] * 4 + 8 : configtmArr[2] + 0;
					if(parseInt(configtmArr[4]) < 4) {
						_MyTextFormat.color = configtmArr[4] == "1" ? 0x990033 : (configtmArr[4] == "2" ? 0x333333 : 0xff6e26); //跟舞台上对象要保持统一
					}
					_MyTextFormat.font = "苹方 细体";
					_MyTextFormat.position = configtmArr[6];
					_flashVars[i] = _MyTextFormat;
				} else if(i == "dots" && (typeof(argobj[i]) == "object")) {
					var obj: Object = {
						"Time": argobj[i].Time,
						"DotText": argobj[i].DotText
					}
					_flashVars['dots'].push(obj);
					_flashVars['dots'].sortOn('Time', Array.NUMERIC); //对打点列表进行时间排序
					for(var o: int = 0; o < _flashVars['dots'].length; o++) {
						ExternalInterface.call("consolesome", " dot" + o + ":" + _flashVars['dots'][o]["Time"] + " " + _flashVars['dots'][o]["DotText"]);
					}
				} else {
					_flashVars[i] = argobj[i];
				}
			}
		}
		public function getTmDefault():String{
			return _flashVars["tmdefault"];
			}
		public function getDots(): Array {
			return _flashVars["dots"];
		}
		public function getLight(): Boolean {
			return _flashVars["light"];
		}
		public function getiNowTime(): int {
			var num:int=0;
			if(_root.isLiveVideo||_root.livetime_C>0){
				if(!_root.isPlayed){
					num= _root.livetime_C;	
					}else{
					num= _root.livetime_C+_root.ns.time;		
						}		
				}else{
					num= _root.ns.time;
					}
			return (num);
		}
		public function getSeeTimes(): int {
				var num:int=0;
			if(_root.isLiveVideo||_root.livetime_C>0){
				if(!_root.isPlayed){
					num= _root.livetime_C;	
					}else{
					num= _root.livetime_C+_root.ns.time;		
						}		
				}else{
					num= _root.ns.time;
				
					}
			return (num);
		}
		public function getFullStatu(): Boolean {
			return _root.isFuscreen;
		}
		public function getPlayStatu(): Boolean {
			return _root.isPlayed;
		}
		public function getVolume(): Number {
			return  _root._volume;
		}
		public function play2() {
			_root.controller.playPause.gotoAndStop(1);
			_root.videomsk.gotoAndStop(1);
			TweenLite.to(_root.videomsk,.3,{alpha:0}); 
			if(isNaN(_root.ns.time)){
				_root.Simplest_as3_rtmp_player();
			}
			_root.livetime_C=_root.livetime_C;
			_root.video_interval.start();
			_root.ns.resume()
			_root.isPlayed =true;
		
		}
		public function	pause2() {
				_root.videomsk.gotoAndStop(2);
			TweenLite.to(_root.videomsk,.3,{alpha:1});
			_root.video_interval.stop();
			_root.livetime_C=_root.livetime_C+_root.ns.time;
			_root.ns.pause();
			_root.isPlayed = false;
			_root.controller.playPause.gotoAndStop(2);
		}
		public function seek2(tim: Number) {
			ExternalInterface.call("consolesome", "tim:"+tim);
			if(!_root.isLiveVideo){
			_root.ns.seek(tim);
		}
		}
	}

}