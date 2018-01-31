//第一个文件  信息中心的接口
package com.dp.Observer {
	import com.dp.Observer.Booker;
	public interface IMessageCenter {
		//订阅 参数为订阅者
		function book(bo: Booker):void;
		//退订 参数为订阅者
		function unbook(bo: Booker):void;
		//派遣、发布
		function send(obj:Object):void;
	}
}