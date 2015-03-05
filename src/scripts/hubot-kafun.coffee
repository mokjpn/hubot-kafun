# Description:
#   Showing of つくばの花粉情報
#
# Dependencies:
#   None
#
# Configuration:
#
# Commands:
#   hubot kafun me     - Show the today's pollen status in Japanese

http = require('http')
url = process.env.HUBOT_KAFUN_URL
monitor = process.env.HUBOT_KAFUN_MONITOR
# url = "http://www.drk7.jp/weather/json/pollen/08.js"
# monitor = "独立行政法人国立環境研究所"
parensRegex = /(^\(|\);?\s*$)/
functionRegex = /^[a-z\d_\.]*\(/i

commentsmily = {
  "少ない" : ":relaxed:"
  "やや多い" :":worried:"
  "多い":":cry:"
  "非常に多い":":sob:"
  "猛烈に多い":":scream:"
  "死ぬほど多い":":skull:"
}

module.exports = (robot) ->
  robot.respond /kafun me/i, (msg) ->
# x=() ->
    http.get(url, (res) ->
      body = ''
      res.on('data', (chunk) ->
        body += chunk
      )
      res.on('end', ->
        wb = body.replace(functionRegex, "").replace(parensRegex, "")
        w = JSON.parse(wb)
        d = w.pref.monitoring[monitor].measurement
        time = new Date().getHours()
        dif = {}
        dif["diff"] = 24
        dif["index"] = 0
        for i in [0..d.length-1]
          dh = d[i]
          difh = time - dh.hour
          if difh < dif["diff"]
            dif["diff"] = difh
            dif["index"] = i
        pd = d[dif["index"]]
        comment = pd.comment + commentsmily[pd.comment]
        msg.send("#{pd.hour}時の#{monitor}測定の花粉飛散量は #{pd.pollen} 個/m3で、 #{comment}です。")
      )
    )

# x()
