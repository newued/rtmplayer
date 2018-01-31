/**
 * rtmpplayerJS插件 com.newued.wzk
 *约定： 所有时间相关都以秒为单位; 所有字符串及键名都使用''包括  @是用户无法输入的字符，如果用户输入这两个字符，会自动进行转义符代替
 * ===========js中可以设置功能============
 ******初始化设置****
 * 视频类型及地址（点播，直播） 播放器窗口比例默认16:9 默认音量大小是0.8 默认清晰度 默认是否自动播放 默认是否支持随意拖动 默认弹幕是否显示 DB设置从指定时间点播放  DB设置缩略图多久产生一个  字幕列表  打点列表 开关灯
 ******初始化设置end***
 * 向播放器传递弹幕设置信息 及弹幕文字
 * DB设置打点信息及文字
 * 设置字幕
 * DB设置点击微视频按钮后只播放打点时间段
 * ==========flash功能==========
 * ZB: 暂停 播放 音量 开关灯 设置窗口比例 刷新播放地址 弹幕显示切换
 * DB: 暂停 播放 音量 开关灯 设置窗口比例（js刷新播放地址）  seek播放 弹幕显示切换   停止 回看n秒 打点显示 缩略图显示
 * --------------------
 * 返回给js：
 * 点播视频当前已播放时间
 * 直播已观看时长
 *DB 打点列表
 *通知js开关灯
 *
 *
 */
var RTMPPlayer = (function(mod) {　　　　　　　
    //return外声明的变量外部不可见
    var playerId = 'playerId'; //播放器Id
    var flashVars = {
		video:[],
	    lv: 0, //0普通形式 1=直播形式 默认是0 ，直播时播放器的进度条将被锁定/隐藏。显示时间的文本内容也显示为= 已播放时长：05：14
        wh: '16:9', //默认比例  
        v: 0.8, //默认音量   
        c: 1, //默认清晰度   0标清,1高清,2超清
        tm: false, //默认是否开启设置弹幕  默认true是开启 false不开启
        configtm: { 'font': '2', 'color': '1', 'position': '1' }, //默认弹幕设置 (position: 1顶部 2中间  3底部）
        tmdefault: '你好', //默认tm幕
        subtitles: [], //设置字幕[{'BeginTime':t,'EndTime':d，'Text':'sdfewfewfewgwgew'}]
        dots: [], //默认打点列表[{'Time':80,'DotText':'我是打点文字'}]
        light: true, //开关灯 默认true开  false关,
		p: 0, //默认自动播放 数值 0 默认不自动播放 1加载后播放 2 默认播放 	//初始化后不可修改
        h: 0, //是否支持随意拖动进度条 默认支持 1为不支持  			    	//初始化后不可修改
		start: 0, //默认从指定时间点开始播放 								//初始化后不可修改
        thumbtime: 3 //设置缩略图多久产生一个 单位秒 默认3秒, 				//初始化后不可修改
    };
    var compareBy = function(subtitles) {
        for (var i in subtitles) {
            if (subtitles[i]['BeginTime'] >= subtitles[i]['EndTime']) {
                console.log(subtitles[i], '开始时间不能大于结束时间');
                subtitles.splice(i, 1);
            }
        }
        return subtitles;
    };
    var removeReat = function(_subtitles) {
        /*对字幕列表进行处理，去除时间交叉的字幕对象中时间范围较大的对象*/
        for (var i = 0; i < _subtitles.length; i++) {
            if (i == _subtitles.length - 1) {

            } else {
                if (_subtitles[i]['EndTime'] > _subtitles[i + 1]['BeginTime']) {
                    var numArea0 = _subtitles[i]['EndTime'] - _subtitles[i]['BeginTime']
                    var numArea1 = _subtitles[i + 1]['EndTime'] - _subtitles[i + 1]['BeginTime']
                    if (numArea0 >= numArea1) {
                        _subtitles.splice(i, 1)
                    }
                    removeReat(_subtitles)
                }
            }
        }
        return _subtitles
    };
    var sortBy = function(filed, rev, primer) {
        /*键值对数组排序， filed排序依赖关键字，rev是否倒序，primer（排序前进行数据处理的函数,常见的是parseInt，Math.floor等，不改变原数组）*/
        rev = (rev) ? -1 : 1;
        return function(a, b) {
            a = a[filed];
            b = b[filed];
            if (typeof(primer) != 'undefined') {
                a = primer(a);
                b = primer(b);
            }
            if (a < b) { return rev * -1; }
            if (a > b) { return rev * 1; }
            return 1;
        }
    };
    var thisMovie = function(movieName) {
        if (navigator.appName.indexOf("Microsoft") != -1) {
			if (window.navigator.userAgent.indexOf("MSIE")>=1) {
				return window[movieName][0];
			}else{
				return window[movieName];
			}
            return window[movieName];
        }else {
            return document[movieName];
        }
    };
    /*
    var	subtitle= {'BeginTime':t,'EndTime':d，'Text':'sdfewfewfewgwgew'}；//字幕对象,单个时间
    var	subtitles= [{'BeginTime':t,'EndTime':d，'Text':'sdfewfewfewgwgew'}]；//字幕对象
    var dotDemo={};//打点对象 如{'Time':t,'DotText':'sdfewfewfewgwgew'};
    */
    return {
        nowFlashVars: function() {
            return getflashvars(flashVars);
        },
        ///////////////////操作flashVars数据/////////////////////
        configTm: function(obj) {
            //	obj形式{Font：“字体”，Color：'#ff6e26'，Position：'top'};
            // thisMovie(playerId).configTm(obj);
            flashVars['configTm'] = obj;
						var ctStr = '';
                        for (var con in obj) {
                            ctStr = ctStr + '@'+con + '@' + obj[con] 
                        }
                        obj = ctStr;
            this.changeFlashVars({ 'configtm': obj })
        },
        setTm: function(vText) {
            //	vText形式'告诉你谁是世界上最美的人'	
			if(vText.length>0){
			vText=vText.slice(0,25);			
            flashVars['tmdefault'] = vText;
            this.changeFlashVars({ 'tmdefault': vText })
			}else{
				alert('弹幕不能为空字符串');
			}
        },
        addSubtitle: function(subtitle) {
            if (subtitle['BeginTime'] >= subtitle['EndTime'])
                flashVars['subtitles'].push(subtitle);
            flashVars['subtitles'].sort(sortBy('BeginTime', false, parseInt)); //对字幕列表进行时间排序
            flashVars['subtitles'] = removeReat(flashVars['subtitles']); //对字幕列表进行处理，并返回新的字幕列表
            this.changeFlashVars({'subtitles': flashVars['subtitles'] })
        },
        adddot: function(dotDemo) {
            if (dotDemo) {	
			dotDemo.DotText=dotDemo.DotText.slice(0,128);
                this.changeFlashVars({ 'dots': dotDemo });
            }
        },
        setLight: function(b) {
				var newLight=b||!this.getLight();
		this.changeFlashVars({ 'light':newLight })
        },

        ///////////////////////////操作swf播放器////////////////////
		getTmDefault: function() {
			return thisMovie(playerId).getTmDefault();
		},
        getPlayStatu: function() {
            //获取播放器播放状态 //如果正在播放 则返回是true,否则返回false
            return thisMovie(playerId).getPlayStatu();
        },
        getiNowTime: function() {
            //获取播放器当前播放时间
            return thisMovie(playerId).getiNowTime();
        },
        getSeeTimes: function() {
            //获取播放器直播已观看时长
            return thisMovie(playerId).getSeeTimes();
        },
        getFullStatu: function() {
            //获取播放器全屏状态，如果当前是全屏，则返回true,非全屏则返回false
            return thisMovie(playerId).getFullStatu();
        },
        getVolume: function() {
            //获取播放器音量 静音为0 ，最大大值为1
            return thisMovie(playerId).getVolume();
        },
		getLight:function(){
			return thisMovie(playerId).getLight();
		},
		getDots: function() {
            //获取播放器音量 静音为0 ，最大大值为1
            return thisMovie(playerId).getDots();
        },
        play2: function() {
            //播放视频
            thisMovie(playerId).play2();
        },
        pause2: function() {
            //暂停视频
            thisMovie(playerId).pause2();
        },
        seek2: function(t) {
            //跳转视频  t为秒
            thisMovie(playerId).seek2(t);
        },
        changeFlashVars: function(obj) {
            //重新发送flashVars
            thisMovie(playerId).changeFlashVars(obj);
        },
        /*
        addEventListener:function('name','handle'){
        },
        */
        getpath: function(z) {
            var f = 'CDEFGHIJKLMNOPQRSTUVWXYZcdefghijklmnopqrstuvwxyz';
            var w = z.substr(0, 1);
            if (f.indexOf(w) > -1 && (z.substr(0, 4) == w + '://' || z.substr(0, 4) == w + ':\\')) {
                return z;
            }
            var d = unescape(window.location.href).replace('file:///', '');
            var k = parseInt(document.location.port);
            var u = document.location.protocol + '//' + document.location.hostname;
            var l = '',
                e = '',
                t = '';
            var s = 0;
            var r = unescape(z).split('//');
            if (r.length > 0) {
                l = r[0] + '//'
            }
            var h = 'http|https|ftp|rtsp|mms|ftp|rtmp|file';
            var a = h.split('|');
            if (k != 80 && k) {
                u += ':' + k;
            }
            for (i = 0; i < a.length; i++) {
                if ((a[i] + '://') == l) {
                    s = 1;
                    break;
                }
            }
            if (s == 0) {
                if (z.substr(0, 1) == '/') {
                    t = u + z;
                } else {
                    e = d.substring(0, d.lastIndexOf('/') + 1).replace('\\', '/');
                    var w = z.replace('../', './');
                    var u = w.split('./');
                    var n = u.length;
                    var r = w.replace('./', '');
                    var q = e.split('/');
                    var j = q.length - n;
                    for (i = 0; i < j; i++) {
                        t += q[i] + '/';
                    }
                    t += r;
                }
            } else {
                t = z;
            }
            return t;
        },
        embed: function(swfPath, containerId, _playerId, userflashVar) {
            playerId = _playerId;
            for (var p in userflashVar) {
                for (var u in flashVars) {
                    if (u == p) {
                        flashVars[u] = userflashVar[p];
                    }
                }
            }
            var swfObject = '<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" id="' + _playerId + '" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,19,0" width="100%" height="100%" >' +
                '<param name="movie" value="' + swfPath +  '" />' +
                '<param name="quality" value="high" />' +
				'<param name="allowFullScreen" value="true"> '+
				'<param name="allowScriptAccess" value="always"> '+
				'<param name="allowFullScreenInteractive" value="true"> '+
                '<param name="flashVars" value=' + this.getflashvars(flashVars) + ' />' +
                '<embed name="' + _playerId + '" src="' + swfPath+ '"  FlashVars= ' + this.getflashvars(flashVars) + ' quality="high" allowScriptAccess="always" allowFullScreen="true" allowFullScreenInteractive="true" pluginspage="http://www.macromedia.com/go/getflashplayer" type="application/x-shockwave-flash" width="100%" height="100%" ></embed>' +
                '</object>';
                /**
                 * a是播放器地址 cintainerId是容器Id playerId是播放器namme, 宽 高 初始化参数其内f是必有的 
                 */
            document.getElementById(containerId).innerHTML = swfObject;
        },
        getflashvars: function(s) {
            var v = '',
                i = 0;
            if (s) {
                for (var k in s) {
                    if (i > 0) {
                        v += '&';
                    }
                    if (k == 'f' && s[k]) {
                        s[k] = this.getpath(s[k]);
                        if (s[k].indexOf('&') > -1) {
                            s[k] = encodeURIComponent(s[k]);
                        }
                    }
					if (k == 'video' && s[k] && typeof s[k] == "object") {
                        var ctStr = '';
                        for (var con in s[k]) {
                            ctStr = ctStr + '@'+this.getpath(s[k][con][0]) + '@' + s[k][con][1]; 
                        }
                        s[k] = ctStr;
						console.log(k+":"+s[k])
                    }
                    if (k == 'configtm' && s[k] && typeof s[k] == "object") {
					
                        var ctStr = '';
                        for (var con in s[k]) {
                            ctStr = ctStr + '@'+con + '@' + s[k][con] 
                        }
                        s[k] = ctStr;
                    }
					if (k == 'dots' && s[k] && typeof s[k] == "object") {
                        var ctStr = '';
                        for (var con in s[k]) {
                            ctStr = ctStr + '@'+s[k][con].Time + '@' + s[k][con].DotText 
                        }
                        s[k] = ctStr;
                    }
					if (k == 'subtitles' && s[k] && typeof s[k] == "object") {
                        var ctStr = '';
                        for (var con in s[k]) {
                            ctStr = ctStr + '@'+s[k][con].BeginTime + '@' + s[k][con].EndTime + '@' + s[k][con].Text 
                        }
                        s[k] = ctStr;
                        // s[k] = this.getpath(s[k]);
                    }
					
                    v += k + '=' + s[k];
                    i++;
                }
            }
            return v;
        },
        format: function() {
            //**** */
        }

    }　　
})(window || document || {});
//调用 RTMPPllayer.add(2);