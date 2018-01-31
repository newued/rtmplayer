package com.dp {
	
	/*
	单例模式类
		在主时间轴引入并声明
	*/
import flash.display.Sprite;
import flash.display.MovieClip;
import com.dp.Custom.MyEvent;
import com.dp.Interface.IntefaceMan;
import com.dp.Data.FlashVars;
	public class Main extends Sprite {
		private var  _intefaceMan:IntefaceMan=new IntefaceMan();
		public function Main() {
			this.addChild(_intefaceMan);
		}
		public function getFlashVars():Object {
			return _intefaceMan.getFlashVars();
		}

		public function get(_name: String): * {


			//获取flashVars
		}

	}

}