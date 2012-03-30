简陋 & 简单 (Just For Bak)


Init Params:
-------------------------------------------------------------------------------------
gid           String    实例唯一标示(由创建者自行传入,不传入flash内部也会自动生成)

size          Number      最大文件尺寸(单位: 字节, 默认: 5242880)

onReady       Function    flash初始化、事件绑定、对外API注册均完成时, 参数(gid)

onStart       Function    开始上传时, 参数(gid)

onSelect      Function    选择了文件时, 参数(gid, file),
							file: 被选择文件描述对象(name, size, type, data, creator, creationDate, modificationDate)

onComplete    Function    上传完成（且接收到后端的数据返回）时, 参数(gid, url),  url: 图片存放地址

onProgress    Function    上传进度通知, 参数(gid, percent)
							percent: 0 ~ 100

onError       Function    发生错误时, 参数(gid, code)
							code: -1: 未选择, -2: 尺寸过大 , -3: IO错误, -4: 安全错误, -5: 正在上传, -6: 未知错误

onCancel      Function    上传取消时, 参数(gid)




Public API:
-----------------------------------------
submit(targetUrl)    执行上传
						targetUrl: 自定义上传服务接口地址

reset()              执行重置初始化

cancel()             取消上传


