//第四个文件 信息发布中心
package com.dp.Observer {
	import com.dp.Observer.IMessageCenter;
	public class MessageCenter implements IMessageCenter {
		private var mess: Object = new Object()
		private var bookers_arr: Array = new Array();
		
		
		public function MessageCenter() {}
		//订阅
		public function book(bo: Booker): void {
			//如果在订阅者群体（bookers_arr）中不存这个订阅者(bo),就把这个订阅
			//者加入到订阅者群体中
			if (bookers_arr.indexOf(bo) < 0) {
				bookers_arr.push(bo);
			};
		}
		//退订
		public function unbook(bo: Booker): void {
			//在订阅者群体中找到这个订阅者，然后帮他办理退订业务
			var b_index: int = bookers_arr.indexOf(bo);
			if (b_index >= 0) {
				bookers_arr.splice(b_index, 1);
			}
		}
		public function send(obj:Object): void {
			/*
			obj是个键值对object，键名要用''

			*/
			if(obj!=undefined&&obj!=null){
				mess=obj;			
				}
			//给订阅者群体中的每个订阅者发送信息（报刊）
			var bookers_len: Number = bookers_arr.length;
			for (var i: Number = 0; i < bookers_len; i++) {
				bookers_arr[i].update(mess);
			}
			mess={};
		}
	}
}