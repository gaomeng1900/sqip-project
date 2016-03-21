console.log 'newslist'

Vue.config.debug = true

Vue.filter('removeHTML', (str) ->
    str = str.replace(/<\/?[^>]*>/g,'')
    str = str.replace(/[ | ]*\n/g,'\n')
    str = str.replace(/\n[\s| | ]*\r/g,'\n')
    str = str.replace(/&nbsp;/ig,'')
    return str
    )

Vue.filter('lenLimit', (str, l) ->
    return str.toString().slice(0,l)
    )

newslist_tpl = '''
<div class="list_panel">
	<div class="list_panel_header">
		当前活动 &gt; {{project_name}}
	</div>
	<ul>
		<a href="//www.yiban.cn/blog/index/otherblog/suid/{{news.User_id}}/blogid/{{news.id}}" v-for="news of news_list" track-by="$index" transition="expand">
			<li>
				<div class="thumbnail" style="background-image: url({{news.fimage ? news.fimage : 'http://www.yiban.cn/upload/system/201603/160304155044413800.jpg'}});"></div>
				<div class="text">
					<h3>{{news.title}}</h3>
					<p class="abstra">{{news.content | removeHTML | lenLimit 90}}</p>
					<div class="info"><span class="time"><i class="iconfont">&#58889;</i>{{news.updateTime | lenLimit 10}}</span></div>
				</div>
				<div class="clear"></div>
			</li>
		</a>
	</ul>
	<div class="clear"></div>
	<div id="rolling_tips">{{rolling_tips}}</div>
</div>
'''

style = document.createElement('style')
style.innerHTML = '''
/* 必需 */
.expand-transition {
  transition: all .3s ease;
  transform:scale(1,1);
  opacity: 1;
}

/* .expand-enter 定义进入的开始状态 */
/* .expand-leave 定义离开的结束状态 */
.expand-enter, .expand-leave {
  opacity: 0;
  transform:scale(.7,.7);
}
'''
document.getElementsByTagName('HEAD').item(0).appendChild(style)

Vue.component('newslist', {
	template: newslist_tpl
	data: ()->
		{
			news_list : []
			page_num : 1
			max_page : 2
			end_of_rolling : 0
			rolling_tips: "...."
			time:0
			project_name: ""
			project_id:""
			size: 6
		}
	methods:
		add_items: ()->
			console.log "add_items ing ..."
			if not @end_of_rolling
				# console.log @$el
				@rolling_tips = "载入中...."
				this.$http.get(('/api/v1/projects/'+@project_id+'/news'), params={page:@page_num, size:@size})
				.then(
					(response)->
						if response.data.news_list and response.data.news_list.length > 0
							this.news_list = this.news_list.concat( response.data.news_list)
							@page_num++
							console.log  response.data.max_page
							if @page_num > response.data.max_page
								@end_of_rolling = 1
								@rolling_tips = "no more"
							else:
								@rolling_tips = "下拉刷新"
							setTimeout @height_mercy, 300
						return
					, (response)->
						if response.data.error_code == "E49"
							alert "no more"
							@rolling_tips = "no more"
						else
							console.log response.data
						
					)
			else
				@rolling_tips = "no more"
		height_mercy: ()->
			if document.body.offsetHeight <= window.screen.height
				@time++
				@add_items()
		data_init: ()->
			if the_pro
				@project_name = the_pro.pro_name
				@project_id = the_pro.id
			else
				alert "newslist: need pro"
	created: ()->
		@data_init()
		@add_items()
		return
	events:
		'get-bottom':	'add_items'

	}
)