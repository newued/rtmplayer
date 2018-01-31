//第三个文件 订阅者
package com.dp.Observer {
	import com.dp.Observer.IBooker;
	import com.dp.Custom.MyEvent;
	public class Booker implements IBooker {	
		//订阅者的用户名SS
		private var _name: String;
		//主时间轴
		private var _timeline:Object;  
		private var _tm:Object;
		public function Booker(name: String,timeline:Object,...rest) {
			//初始化时候定义用户名
			_name = name;
			_tm=rest[0];
				_timeline=timeline;
			
		}
		public function update(obj: Object): void {
			//str为收到的信息,对收到的信息进行筛选，需要的继续执行
			if(obj==_tm)
			_timeline.dispatchEvent(new MyEvent(MyEvent.FLASHVARS_CHANGE, "自定义事件")); 
			trace(_name + "收到消息:" );
		}
	}
}