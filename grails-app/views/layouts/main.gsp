<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
		<title><g:layoutTitle default="Grails"/></title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta name="description" content="Genesis - The origin of genes" />
        <meta name="author" content="Henrique Velloso">
		<link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
		<link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
		<link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">
		<link rel="stylesheet" href="${resource(dir: 'css', file: 'business-casual.css')}" type="text/css">
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'bootstrap.css')}" type="text/css">
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'style.css')}" type="text/css">
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'tablet.css')}" type="text/css">
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css">



    <g:javascript library="jquery"/>


    <g:layoutHead/>
		<r:layoutResources />
	</head>
	<body>
        <div class="brand">Genesis</div>
        <div class="address-bar">The origin of genes</div>

        <nav class="navbar navbar-default" role="navigation">
            <div class="container">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
                        <span class="sr-only">Toggle navigation</span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                    </button>
                    <a class="navbar-brand" href="index.html">GENESIS</a>
                </div>

                <!-- Collect the nav links, forms, and other content for toggling -->
                <div class="collapse navbar-collapse navbar-ex1-collapse">
                    <ul class="nav navbar-nav">
                        <li><a href="${createLink(uri: '/')}">KO Origin</a></li>
                        <li><a href="${createLink(controller: 'species', action: 'index')}">Species Origin</a></li>
                        <li><a href="${createLink(controller: 'multiLCATree', action: 'index')}">MultiLCA Tree</a></li>
                        <li><a href="#">About</a></li>
                        <li><a href="#">Contact</a></li>
                    </ul>
                </div><!-- /.navbar-collapse -->
            </div><!-- /.container -->
        </nav>
        <style>
        #circularG{
            position:relative;
            width:60px;
            height:60px}

        .circularG{
            position:absolute;
            background-color:#468AD9;
            width:14px;
            height:14px;
            -moz-border-radius:9px;
            -moz-animation-name:bounce_circularG;
            -moz-animation-duration:0.96s;
            -moz-animation-iteration-count:infinite;
            -moz-animation-direction:linear;
            -webkit-border-radius:9px;
            -webkit-animation-name:bounce_circularG;
            -webkit-animation-duration:0.96s;
            -webkit-animation-iteration-count:infinite;
            -webkit-animation-direction:linear;
            -ms-border-radius:9px;
            -ms-animation-name:bounce_circularG;
            -ms-animation-duration:0.96s;
            -ms-animation-iteration-count:infinite;
            -ms-animation-direction:linear;
            -o-border-radius:9px;
            -o-animation-name:bounce_circularG;
            -o-animation-duration:0.96s;
            -o-animation-iteration-count:infinite;
            -o-animation-direction:linear;
            border-radius:9px;
            animation-name:bounce_circularG;
            animation-duration:0.96s;
            animation-iteration-count:infinite;
            animation-direction:linear;
        }

        #circularG_1{
            left:0;
            top:24px;
            -moz-animation-delay:0.36s;
            -webkit-animation-delay:0.36s;
            -ms-animation-delay:0.36s;
            -o-animation-delay:0.36s;
            animation-delay:0.36s;
        }

        #circularG_2{
            left:6px;
            top:6px;
            -moz-animation-delay:0.48s;
            -webkit-animation-delay:0.48s;
            -ms-animation-delay:0.48s;
            -o-animation-delay:0.48s;
            animation-delay:0.48s;
        }

        #circularG_3{
            top:0;
            left:24px;
            -moz-animation-delay:0.6s;
            -webkit-animation-delay:0.6s;
            -ms-animation-delay:0.6s;
            -o-animation-delay:0.6s;
            animation-delay:0.6s;
        }

        #circularG_4{
            right:6px;
            top:6px;
            -moz-animation-delay:0.72s;
            -webkit-animation-delay:0.72s;
            -ms-animation-delay:0.72s;
            -o-animation-delay:0.72s;
            animation-delay:0.72s;
        }

        #circularG_5{
            right:0;
            top:24px;
            -moz-animation-delay:0.84s;
            -webkit-animation-delay:0.84s;
            -ms-animation-delay:0.84s;
            -o-animation-delay:0.84s;
            animation-delay:0.84s;
        }

        #circularG_6{
            right:6px;
            bottom:6px;
            -moz-animation-delay:0.96s;
            -webkit-animation-delay:0.96s;
            -ms-animation-delay:0.96s;
            -o-animation-delay:0.96s;
            animation-delay:0.96s;
        }

        #circularG_7{
            left:24px;
            bottom:0;
            -moz-animation-delay:1.08s;
            -webkit-animation-delay:1.08s;
            -ms-animation-delay:1.08s;
            -o-animation-delay:1.08s;
            animation-delay:1.08s;
        }

        #circularG_8{
            left:6px;
            bottom:6px;
            -moz-animation-delay:1.2s;
            -webkit-animation-delay:1.2s;
            -ms-animation-delay:1.2s;
            -o-animation-delay:1.2s;
            animation-delay:1.2s;
        }

        @-moz-keyframes bounce_circularG {
            0% {
                -moz-transform:scale(1)}

            100% {
                -moz-transform:scale(.3)}

        }

        @-webkit-keyframes bounce_circularG{
            0% {
                -webkit-transform:scale(1)}

            100% {
                -webkit-transform:scale(.3)}

        }

        @-ms-keyframes bounce_circularG{
            0% {
                -ms-transform:scale(1)}

            100% {
                -ms-transform:scale(.3)}

        }

        @-o-keyframes bounce_circularG{
            0% {
                -o-transform:scale(1)}

            100% {
                -o-transform:scale(.3)}

        }

        @keyframes bounce_circularG{
            0% {
                transform:scale(1)}

            100% {
                transform:scale(.3)}
        }

        </style>

        <!-- Modal -->
        <div class="modal fade" id="waitingModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" style="width: 200px; padding-top: 250px;">
                <div class="modal-content">

                    <div class="modal-body">
                        <div id="circularG" style="margin-left: 36px;">
                            <div id="circularG_1" class="circularG">
                            </div>

                            <div id="circularG_2" class="circularG"> </div>

                            <div id="circularG_3" class="circularG"> </div>
                            <div id="circularG_4" class="circularG">
                            </div>
                            <div id="circularG_5" class="circularG">
                            </div>
                            <div id="circularG_6" class="circularG">
                            </div>
                            <div id="circularG_7" class="circularG">
                            </div>
                            <div id="circularG_8" class="circularG">
                            </div>
                        </div>

                        <p style="text-align: center;margin:15px 0 0px">Please wait...</p>
                    </div>

                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->

        <!-- Modal -->
        <div class="modal fade" id="alertModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" style="width: 500px; padding-top: 250px;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title" id="myModalLabel">Message</h4>
                    </div>
                    <div class="modal-body">
                        <p style="color: green; text-align: left;margin:15px 0 0px">${flash.message}</p>
                    </div>

                </div>
            </div>
        </div>


        <g:layoutBody/>

        <g:if test="${flash.message}">
            <script type="text/javascript">
                $(document).ready(function(){
                    $('#alertModal').modal({
                        keyboard: true
                    });
                });
            </script>

        </g:if>


        <script language="javascript">

            jQuery.ajaxSetup({
                beforeSend: function() {
                    $('#waitingModal').modal({
                        keyboard: false,
                        backdrop: 'static'
                    });
                },
                complete: function(){
                    $('#waitingModal').modal('hide');
                },
                success: function() {}
            });
        </script>

		<g:javascript library="application"/>
        <g:javascript src="bootstrap.js" />

        <r:layoutResources />





    </body>
</html>
