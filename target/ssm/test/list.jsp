
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <title>layui在线调试</title>
    <link rel="stylesheet" href="layui/css/layui.css" media="all">
    <style>
        body{margin: 10px;}
        .demo-carousel{height: 200px; line-height: 200px; text-align: center;}
    </style>
</head>
<body>
<div class="weadmin-nav">
			<span class="layui-breadcrumb">
				<a href="javascript:;">首页</a> <a href="javascript:;">会员管理</a>
				<a href="javascript:;"> <cite>会员列表</cite></a>
			</span>
    <a class="layui-btn layui-btn-sm" style="margin-top:3px;float:right" href="javascript:location.replace(location.href);"
       title="刷新">
        <i class="layui-icon layui-icon-refresh"></i>
        <!-- <i class="layui-icon" style="line-height:30px">&#x1002;</i> -->
    </a>
</div>

<div class="weadmin-body">
    <div class="layui-row">
        <form class="layui-form layui-col-md12 we-search">
            会员搜索：
            <div class="layui-inline">
                <input class="layui-input" placeholder="开始日" name="start" id="start" />
            </div>
            <div class="layui-inline">
                <input class="layui-input" placeholder="截止日" name="end" id="end" />
            </div>
            <div class="layui-inline">
                <input type="text" name="username" placeholder="请输入用户名" autocomplete="off" class="layui-input" />
            </div>
            <button class="layui-btn" lay-submit="" lay-filter="sreach">
                <i class="layui-icon layui-icon-search"></i>
            </button>
        </form>
    </div>
</div>
</div>

<table class="layui-hide" id="demo" lay-filter="test"></table>

<script type="text/html" id="barDemo">
    <a class="layui-btn layui-btn-primary layui-btn-xs" lay-event="detail">查看</a>
    <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
    <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
</script>


<script src="layui/layui.js"></script>
<script>
    layui.config({
        version: '1573378444586' //为了更新 js 缓存，可忽略
    });

    layui.use(['laydate', 'laypage', 'layer', 'table', 'carousel', 'upload', 'element', 'slider'], function(){
        var laydate = layui.laydate //日期
          var  $=layui.jquery
            ,laypage = layui.laypage //分页
            ,layer = layui.layer //弹层
            ,table = layui.table //表格
            ,carousel = layui.carousel //轮播
            ,upload = layui.upload //上传
            ,element = layui.element //元素操作
            ,slider = layui.slider //滑块

        //向世界问个好
        layer.msg('Hello World');

        //监听Tab切换
        element.on('tab(demo)', function(data){
            layer.tips('切换了 '+ data.index +'：'+ this.innerHTML, this, {
                tips: 1
            });
        });

        //执行一个 table 实例
        table.render({
            elem: '#demo'
            ,height: 420
            ,url: '/findUsers' //数据接口
            ,title: '用户表'
            ,page: true //开启分页
            ,toolbar: 'default' //开启工具栏，此处显示默认图标，可以自定义模板，详见文档
            ,totalRow: true //开启合计行
            ,cols: [[ //表头
                {type: 'checkbox', fixed: 'left'}
                ,{field: 'id', title: 'ID',  sort: true, fixed: 'left', totalRowText: '合计：'}
                ,{field: 'name', title: '用户名'}
                ,{field: 'passwrod', title: '密码', sort: true, totalRow: true}
                ,{fixed: 'right', width: 165, align:'center', toolbar: '#barDemo'}
            ]]
        });

        //监听头工具栏事件
        table.on('toolbar(test)', function(obj){
            var checkStatus = table.checkStatus(obj.config.id)
                ,data = checkStatus.data; //获取选中的数据
            switch(obj.event){
                case 'add':
                    //layer.msg('添加');
                    //弹出添加窗体,加载添加页面
                    //ShowLay(标题,加载页面,宽,高)
                    ShowLay('添加','add.jsp',600,600);

                    break;
                case 'update':
                    if(data.length === 0){
                        layer.msg('请选择一行');
                    } else if(data.length > 1){
                        layer.msg('只能同时编辑一个');
                    } else {
                        layer.alert('编辑 [id]：'+ checkStatus.data[0].id);
                        //修改操作
                        EditLay('修改','edit.html',checkStatus.data[0].id,600,600);
                    }
                    break;
                case 'delete':
                    if(data.length === 0){
                        layer.msg('请选择一行');
                    } else {
                        layer.msg('删除');
                    }
                    break;
            };
        });

        //监听行工具事件
        table.on('tool(test)', function(obj){ //注：tool 是工具条事件名，test 是 table 原始容器的属性 lay-filter="对应的值"
            var data = obj.data //获得当前行数据
                ,layEvent = obj.event; //获得 lay-event 对应的值
            if(layEvent === 'detail'){
                layer.msg('查看操作');
            } else if(layEvent === 'del'){
                layer.confirm('真的删除行么', function(index){
                    obj.del(); //删除对应行（tr）的DOM结构
                    layer.close(index);	//关闭窗口
                    //向服务端发送删除指令
                    $.ajax({
                        url: "/deleteUserById",    //换成自己的url
                        type: "POST",
                        dataType: "json",
                        data: {
                            "id": data.id
                        },
                        success: function (e) {
                            if (e=='1') {
                                layer.msg('删除成功');
                            } else {
                                layer.msg('删除失败');
                            }
                        },
                        error: function (e) {
                            layer.msg(e);
                        }
                    });

                });
            } else if(layEvent === 'edit'){
                //修改操作
                EditLay('修改','edit.jsp',data,600,600);
            }
        });

        //将日期直接嵌套在指定容器中
        var start = laydate.render({
            elem: '#start'
            /* ,position: 'static'
            ,calendar: true //是否开启公历重要节日
            ,mark: { //标记重要日子
              '0-10-14': '生日'
              ,'2018-08-28': '新版'
              ,'2018-10-08': '神秘'
            }
            ,done: function(value, date, endDate){
              if(date.year == 2017 && date.month == 11 && date.date == 30){
                dateIns.hint('一不小心就月底了呢');
              }
            }
            ,change: function(value, date, endDate){
              layer.msg(value)
            } */
        });

        var end = laydate.render({
            elem: '#end'
        });

        //分页
        laypage.render({
            elem: 'pageDemo' //分页容器的id
            ,count: 100 //总页数
            ,skin: '#1E9FFF' //自定义选中色值
            //,skip: true //开启跳页
            ,jump: function(obj, first){
                if(!first){
                    layer.msg('第'+ obj.curr +'页', {offset: 'b'});
                }
            }
        });


        /*
         * @todo 重新计算iframe高度
         */
        function FrameWH() {
            var h = $(window).height() - 164;
            $("iframe").css("height", h + "px");
        }
        $(window).resize(function() {
            FrameWH();
        });

        /*
         * @todo 弹出层，弹窗方法
         * layui.use 加载layui.define 定义的模块，当外部 js 或 onclick调用 use 内部函数时，需要在 use 中定义 window 函数供外部引用
         * http://blog.csdn.net/xcmonline/article/details/75647144
         */
        /*
            参数解释：
            title   标题
            url     请求的url
            id      需要操作的数据id
            w       弹出层宽度（缺省调默认值）
            h       弹出层高度（缺省调默认值）
        */
        function ShowLay(title, url, w, h) {

            if(title == null || title == '') {
                title = false;
            };
            if(url == null || url == '') {
                url = "404.html";
            };
            if(w == null || w == '') {
                w = ($(window).width() * 0.9);
            };
            if(h == null || h == '') {
                h = ($(window).height() - 50);
            };
            layer.open({
                type: 2,
                area: [w + 'px', h + 'px'],
                fix: false, //不固定
                maxmin: true,
                shadeClose: true,
                shade: 0.4,
                title: title,
                content: url,
                end: function(layero, index) {

                    table.reload("demo",{
                        page:{
                            curr:1
                        }
                    });
                }
            });
        }

        /*弹出层+传递ID参数*/
        function EditLay(title, url, data, w, h) {

            if(title == null || title == '') {
                title = false;
            };
            if(url == null || url == '') {
                url = "404.html";
            };
            if(w == null || w == '') {
                w = ($(window).width() * 0.9);
            };
            if(h == null || h == '') {
                h = ($(window).height() - 50);
            };
            layer.open({
                type: 2,
                area: [w + 'px', h + 'px'],
                fix: false, //不固定
                maxmin: true,
                shadeClose: true,
                shade: 0.4,
                title: title,
                content: url,
                success: function(layero, index) {
                    //向iframe页的id=house的元素传值  // 参考 https://yq.aliyun.com/ziliao/133150
                    var body = layer.getChildFrame('body', index);
                    body.contents().find("#id").val(data.id);
                    body.contents().find("#name").val(data.name);
                    body.contents().find("#passwrod").val(data.passwrod);

                },
                error: function(layero, index) {
                    alert("异常错误！");
                },
                end: function(layero, index) {

                    table.reload("demo",{
                        page:{
                            curr:1
                        }
                    });
                }

            });
        }



    });
</script>
</body>
</html>
