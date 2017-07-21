# encoding: utf-8

#从西刺代理获取代理IP
require 'mechanize'
class Get_xici_daili
	#解析IP,并存入csv中
	def parse_ip
		url = 'http://www.xicidaili.com/nn/'
		ip_list = Array.new#存放代理
		html = html(url)
		html.xpath('//table[@id="ip_list"]/tr').each do |tr|
			flog = 0
			ip = ''
			post = ''
			tr.xpath('td').each do |td|
				flog +=1			
				txt = td.content.gsub("\n","").gsub(" ","")
				if flog ==2
					ip = txt
				end
				if flog ==3
					post = txt
					puts ip+":"+post
					ip_list.push(ip+":"+post)
					#将能用的代理存入数组
					if time_out?(ip,post.to_i)
						puts "#{ip}:#{post}存入数组！"
						ip_list.push(ip+":"+post)
					else
						puts "#{ip}:#{post}为失效代理！！"
					end
					# save_daili(ip+post+"\n")
					break
				end
			end
		end
		ip_list
	end

	def html(url)
    begin
      agent = Mechanize.new
      agent.user_agent_alias = 'Mac Safari'
      html = agent.get(url)
      return html
    rescue Exception=> e
      puts "出现异常:"+e.message+"#{url}该链接无法抓取"
      return "0"
    end
  end

	#保存ip到daili.csv
	def save_daili(ip_post)
		file = File.new("daili.csv","ab+")
		file.syswrite(ip_post)
		file.close
	end

	#验证代理是否超时
	#可以用的true
	#不能用的false
	def time_out?(ip,post)
		begin
			agent = Mechanize.new
			agent.set_proxy  ip,post
			agent.get('http://www.baidu.com')
			puts "此代理可用！"
			return true
		rescue Exception => e
			puts "出现异常:#{ip}:#{post}  o_0"+e.message
			return false
		end
	end
end
