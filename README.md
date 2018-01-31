
### 一个rtmp视频播放器(flash版本)
技术框架：actionscript3 html css javascript
## 😂😂😂😂😂  持续更新中😂😂😂😂😂
# 播放器汇总 
  * [PC端]()
    * [rtmplayer](https://github.com/newued/rtmplayer)
    * [flv/f4v播放器（待添加）]()
    * [videojs使用demo（待添加）]()
    * [阿里云播放器使用demo（待添加）]()
    * [腾讯云播放器使用demo（待添加）]()
* [移动端]()
    * [h5直播播放器（待添加）]()
    * [h5点播播放器（待添加）]()
    * [其它]()
    
## 😂😂😂😂😂  持续更新中😂😂😂😂😂
## 功能描述
1.rtmp格式视频播放(点播，直播)<br>
2.提供外部js脚本设置弹幕，打点，弹幕设置，开关灯，播放暂停控制<br>
3.支持缩略图<br>
4.支持断点续播<br>
5.全屏切换<br>

## 使用
step1:把dist目录下的player放在html同级目录中（根据需要引用一个即可）。
step2:引入js脚本
```
        window.onload = function() {
            var myflashVars = {
				video:[
					['rtmp://live.hkstv.hk.lxdns.com/live/hks','标清'],
					['rtmp://120.26.91.134:1935/live/14_0_hs','高清'],
					['rtmp://120.26.91.134:1935/vod/mp4:2_0_hs_0_1500444901_179.mp4','超清']
				],
                lv: 1, //0普通形式 1=直播形式 默认是0 ，直播时播放器的进度条将被锁定/隐藏。显示时间的文本内容也显示为= 已播放时长/60：00
                wh: '16:9', //默认比例  可选1：1原始视频流比例  4：3  
                v: 0.2, //默认音量   
                c: 0, //默认清晰度   0标清,1高清,2超清
                p: 0, //默认自动播放 数值 0 默认不自动播放 1加载后播放 2 默认播放
                h: 0, //是否支持随意拖动进度条 默认支持 1为不支持
                tm: true, //默认是否开启设置弹幕  默认true是开启 false不开启
                configtm: {'font': '2', 'color': '1', 'position': '1' }, //默认弹幕设置 (position: 1顶部 2中间  3底部）
                tmdefault: '你好，欢迎使用本播放器', //默认tm幕
                start: 0, //默认从指定时间点开始播放 
                thumbtime: 5, //设置缩略图多久产生一个 单位秒 默认3秒,
                subtitles: [], //设置字幕[{'BeginTime':5,'EndTime':10,'Text':'我是测试字幕，将显示在第5-10秒'},{'BeginTime':11,'EndTime':19,'Text':'我是测试字幕，将显示在第11-19秒'}]
                dots: [] //默认打点列表[{'Time':80,'DotText':'我是打点文字'}]

            };
            RTMPPlayer.embed('./player/rtmplayer.swf?random='+Math.random()*100, 'flashContent', 'rtmpPlayer', myflashVars)
            jsReady = true;
        }
```
step3:设置css样式，参考下方尺寸建议
step4:添加交互代码
```
        var jsReady = false;//dom是否已经渲染完成
        var swfReady = false;//swf是否加载
		function thisMovie(movieName) {
        if (navigator.appName.indexOf("Microsoft") != -1) {
            return window[movieName];
        } else {
            return document[movieName];
        }
	//必须：告诉flash dom渲染完成
        function isReady() {
            return jsReady;
        }
	//必须：light仅供参考(如不需要开关灯，可以省略)
	function light(c){
		if(c){
		document.getElementById('btngroup').style.background="white";
		//...
		}else{
		document.getElementById('btngroup').style.background="black";
		//...
		}
	}
	//flash加载完成后会调用这个js函数，您可以在此添加一些逻辑，比如用js控制
        function setSWFIsReady() {
            swfReady = true;
            doInterface();//在此方法中添加播放器与js交互逻辑
        }
	 function flashVars() {
		 console.log('flashVars被调用')
            RTMPPlayer.flashVars()
        }
	
	 function doInterface() {
            console.log('swfReady')
			//弹幕设置
            document.getElementById('ta0_1').onclick = function(event) {
		   event = event || window.event;
		   var jsString=strToJson(document.getElementById('ia0').value);
                RTMPPlayer.configTm(jsString)
            }
	    }
```



=======================================================================
## 尺寸建议
```

/**腾讯播放器尺寸**/
//  1789<w
.mod_player_section {
	width: 1390px;
	height: 782px;
}
//  1549<w<=1789
@media （max-width:1789px）{
.mod_player_section {
	width: 1180px;
	height: 664px;
}
}
//  1269<w<=1549
@media （max-width:1549px）{
.mod_player_section {
	width: 880px;
	height: 495px;
}
}
//  1269>w
@media （max-width:1269px）{
.mod_player_section {
	width: 667px;
	height: 375px;
}
}

/***爱奇艺**/

//  1789<w
.mod_player_section {
	width: 1344px;
	height: 597px;
}
//  1440<w<1789
@media （max-width:1789px）{
.mod_player_section {
	width: 1164px;
	height: 496px;
}
}
//  1440>w
@media （max-width:1440px）{
.mod_player_section {
	width: 880px;
	height: 496px;
}
}
```
更多参见接口说明文档和操作文档和示例文件test.html
### 操作文档及接口说明文档
详情见接口说明文档和操作文档
### Contact 联系作者:

#### ![arthur-wang-前端开发多媒体开发工程师](/assets/myphoto_40.png) 

微信:wzk-1314

QQ:2535565243

邮箱：2535565243@qq.com
