console.log 'infopanel'

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

infopanel_tpl = '''
<div class="info_panel">
	<div class="poster" style="background-image: url({{pro.img}});"></div>
	<section>
		<div class="title">{{pro.pro_name}}</div>
		<ul class="info">
			<li>
				<div class="define">
					<i class="iconfont">&#58918;</i> 项目类型: 
				</div>
				<div class="descrip">
					{{pro.type}}
				</div>
			</li>
			<li style="vertical-align:top;">
				<div class="define">
					<i class="iconfont">&#58917;</i> 指导老师: 
				</div>
				<div class="descrip">
					{{pro.tutor}}
				</div>
			</li>
			<li style="vertical-align:top;">
				<div class="define">
					<i class="iconfont">&#58921;</i> 负责人: 
				</div>
				<div class="descrip">
					{{pro.in_charge}}
				</div>
			</li>
			<li style="vertical-align:top;">
				<div class="define">
					<i class="iconfont">&#xe619;</i> 团队: 
				</div>
				<div class="descrip">
					{{pro.staff}}
				</div>
			</li>
			<li style="vertical-align:top;">
				<div class="define">
					<i class="iconfont">&#58912;</i> 活动时间: 
				</div>
				<div class="descrip">
					{{pro.time}}
				</div>
			</li>
			<li style="vertical-align:top;">
				<div class="define">
					<i class="iconfont">&#58886;</i> 活动地点: 
				</div>
				<div class="descrip">
					{{pro.place}}
				</div>
			</li>
			<li style="vertical-align:top;">
				<div class="define">
					<i class="iconfont">&#58903;</i> 状态: 
				</div>
				<div class="descrip">
					{{pro.state}}
				</div>
			</li>
		</ul>
	</section>
	<section>
		<div class="section_title">活动简介</div>
		<p>{{pro.intro}}</p>
	</section>
	<section>
		<div class="section_title">参与方式</div>
		<p>{{pro.join_us}}</p>
	</section>
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

Vue.component('infopanel', {
	template: infopanel_tpl
	data: ()->
		{
			project_id:''
			pro:{}
		}
	methods:
		render: ()->
			if the_pro
				console.log "got pro"
				@pro = the_pro
				@project_id = the_pro.id
			else if project_id
				console.log "got id, rendering"
				@project_id = project_id
				this.$http.get(('http://127.0.0.1:9032/api/v1/projects/'+@project_id), params={page:@page_num, size:@size})
				.then(
					(response)->
						if response.data.status == 'success'
							@pro = response.data.pro
						return
					, (response)->
						if response.data.error_code == "E49"
							alert "no more"
							@rolling_tips = "no more"
						else
							console.log response.data
					)
			else
				alert "need project_id"
			
	created: ()->
		@render()
		return

	}
)