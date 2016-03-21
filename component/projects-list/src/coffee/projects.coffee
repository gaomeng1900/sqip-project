console.log 'projects'

Vue.config.debug = true

projects_list_tpl = '''
<!-- <template id="projects-tpl"> -->
<img class="sec_title" src="/static/img/tutor.jpg">
<div id="projects_wrapper">
	<a class="card" href="/projects/{{pro.id}}" v-for="pro of pros" track-by="$index" transition="expand">
		<div class="card_img" style="background-image: url({{pro.img}});"></div>
		<div class="card_info">
			<div class="card_info_title">{{pro.pro_name}}</div>
			<div class="card_info_content">
				<span class="time"><i class="iconfont">&#58912;</i>{{pro.time}}</span>
				<span class="place"><i class="iconfont">&#58886;</i>{{pro.place}}</span>
			</div>
		</div>
	</a>
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

Vue.component('projects', {
	# template: '#projects-tpl'
	template: projects_list_tpl
	data: ()->
		{
			pros : []
			page_num : 1
			max_page : 2
			end_of_rolling : 0
			rolling_tips: "...."
			time:0
			size:6
		}
	methods:
		add_items: ()->
			console.log "add_items ing ..."
			if not @end_of_rolling
				# console.log @$el
				@rolling_tips = "载入中...."
				this.$http.get(('/api/v1/projects'), params={page:@page_num, size:@size})
				.then(
					(response)->
						if response.data.pros and response.data.pros.length > 0
							this.pros = this.pros.concat( response.data.pros)
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
	created: ()->
		@add_items()
		return
	events:
		'get-bottom':	'add_items'

	}
)
# test002 = new Test002({
# 	data:
# 		entities : []
# 		page_num : 1
# 	methods:
# 		add_items: ()->
# 			this.$http.get('http://api.xunsheng90.com/entity/vwork', params={page_num:@page_num})
# 			.then(
# 				(response)->
# 					if response.data.entities and response.data.entities.length > 0
# 						this.entities = this.entities.concat( response.data.entities)
# 						@page_num++
# 				, (response)->
# 					if response.data.error_code == "E49"
# 						alert "no more"
# 					else
# 						console.log response.data
					
# 				)
# 	created: ()->
# 		@add_items()
# })

# test002.$mount('#test002')

