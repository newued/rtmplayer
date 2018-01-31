package com.dp.Observer {

	import flash.net.NetStreamInfo;
	import flash.net.NetStream;
	public class NetStreamEventMonitor  extends NetStreamInfo{
		private var netmon: NetStreamInfo;
		private var heartbeat: Timer = new Timer(5000);

		public function NetStreamEventMonitor(ns:NetStream) {
			//Create NetMonitor object 
			netmon = ns.info;
			//Start the heartbeat timer 
			heartbeat.addEventListener(TimerEvent.TIMER, onHeartbeat);
			heartbeat.start();
		}

		//On data events from a NetStream object 
		private function onStreamData(event: NetDataEvent): void {

			var netStream: NetStream = event.target as NetStream;
			trace("Data event from " + netStream.info.uri + " at " + event.timestamp);
			switch (event.info.handler) {
				case "onMetaData":
					//handle metadata; 
					break;
				case "onXMPData":
					//handle XMP; 
					break;
				case "onPlayStatus":
					//handle NetStream.Play.Complete 
				case "onImageData":
					//handle image 
					break;
				case "onTextData":
					//handle text 
					break;
				default:
					//handle other events 

			}
		}

		//On status events from a NetStream object 
		private function onStatus(event: NetStatusEvent): void {
			trace("Status event from " + event.target.info.uri + " at " + event.target.time);
			//handle status events 
		}
		//On heartbeat timer 
		private function onHeartbeat(event: TimerEvent): void {
			var streams: Vector.<NetStream> = netmon.listStreams();
			for (var i: int = 0; i < streams.length; i++) {
				trace("Heartbeat on " + streams[i].info.uri + " at " + streams[i].time);
				//handle heartbeat event 
			}
		}

	}
}