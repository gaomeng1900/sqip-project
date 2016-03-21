getScrollTop = ()->
	scrollTop = 0
	bodyScrollTop = 0
	documentScrollTop = 0
	if document.body
		bodyScrollTop = document.body.scrollTop
	if document.documentElement
		documentScrollTop = document.documentElement.scrollTop

	return if (bodyScrollTop - documentScrollTop > 0) then bodyScrollTop else documentScrollTop

# 文档的总高度
getScrollHeight = ()->
	scrollHeight = 0
	bodyScrollHeight = 0
	documentScrollHeight = 0
	if document.body
		bodyScrollHeight = document.body.scrollHeight
	if document.documentElement
		documentScrollHeight = document.documentElement.scrollHeight

	return if (bodyScrollHeight - documentScrollHeight > 0) then bodyScrollHeight else documentScrollHeight

# 浏览器视口的高度
getWindowHeight = ()->
	windowHeight = 0
	if document.compatMode == "CSS1Compat"
		windowHeight = document.documentElement.clientHeight
	else
		windowHeight = document.body.clientHeight
	return windowHeight

# # 滚动到底部后增量刷新
# rolling_page = 0
# end_of_rolling = 0
# refresh_list = () ->
# 	console.log "start"
# 	if end_of_rolling
# 		console.log "end of rolling"
# 	else
# 		# perk.link("list_render_", "refresh_list_");
# 		document.getElementById('rolling_tips').innerHTML = "作品信息更新中...."

# refresh_list_ = (r)->
# 	console.log "back"
# 	if r.curr_args.page_num == r.max_page
# 		document.getElementById('rolling_tips').innerHTML = "没有更多作品"
# 		end_of_rolling = 1
# 	else
# 		rolling_page += 1
# 		document.getElementById('rolling_tips').innerHTML = "下拉刷新"
# 		if document.body.offsetHeight <= window.screen.height
# 			refresh_list()

# window.onscroll = ()->
# 	if getScrollTop() + getWindowHeight() == getScrollHeight()
# 		console.log "reach the bottom"
# 		vvv.$broadcast('get-bottom')

# refresh_list();


# removeHTMLTag = (str) ->
#     str = str.replace(/<\/?[^>]*>/g,'')
#     str = str.replace(/[ | ]*\n/g,'\n')
#     str = str.replace(/\n[\s| | ]*\r/g,'\n')
#     str = str.replace(/&nbsp;/ig,'')
#     return str
