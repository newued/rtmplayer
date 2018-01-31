//第二个文件 订阅者接口
package com.dp.Observer {
	public interface IBooker {
		//我的信箱，邮递员投递信息的邮箱，他把信息扔到你的”updata”这个信箱里。
		function update(obj: Object): void;

	}
}