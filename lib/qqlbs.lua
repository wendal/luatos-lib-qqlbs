
--[[
@module qqlbs
@summary 腾讯智能硬件定位(wifi定位/基站定位)
@version 1.0.0
@date    2024.01.03
@author  wendal
@tag LUAT_USE_NETWORK
@usage
-- 具体用法请查阅demo
-- 腾讯的API文档 https://lbs.qq.com/service/webService/webServiceGuide/location

-- 提醒: 
-- 腾讯的定位服务需要收费, 具体请咨询腾讯. 2024.1.3咨询的答复的免费额度是10000次/天,并发5次/秒.
-- 腾讯的定位服务需要一个key, 登陆 lbs.qq.com 注册,并个人认证后可用, 企业认证的额度一样
-- 返回结果的坐标系是GCJ02
]]

local qqlbs = {}

--[[
请求一次定位
@api qqlbs.req(qqkey)
@string qqkey 腾讯的定位key,必须填写
@return table 返回的定位信息,失败返回nil
@usage
-- 注意, 本API需要在task中调用, 为同步函数
-- 返回的结果类似于
-- {
--    "ad_info":{"city":"广州市","district":"天河区","adcode":"440112","province":"广东省","nation":"中国"},
--    "location":{"longitude":112.2356,"accuracy":500,"altitude":0,"latitude":24.40437},
--    "address":"广东省广州市天河区天河路1号"
-- }

]]
function qqlbs.req(qqkey, cells, wifis, bles)
    if not qqkey or #qqkey ~= 35 then
        log.error("qqlbs", "key错误,必须填入你自己的key")
        return
    end
    if not cells and mobile then
        cells = mobile.getCellInfo()
    end
    if not wifis and wlan then
        wifis = wlan.scanResult()
    end

    local query = {
        key = qqkey,
        device_id = mcu.unique_id():toHex()
    }

    if cells and #cells > 0 then
        -- 基站信息需要处理一下才能使用
        query["cellinfo"] = {}
        for _, cell in ipairs(cells) do
            table.insert(query["cellinfo"], {mcc=cell.mcc, mnc=cell.mnc, lac=cell.tac, cellid=cell.cid,rss=cell.rssi})
        end
    end

    if wifis and #wifis > 0 then
        -- wifi信息需要处理一下才能使用
        query["wifiinfo"] = {}
        for k,v in pairs(wifis) do
            -- log.info("scan", v["ssid"], v["rssi"], (v["bssid"]:toHex()))
            local tmp = {}
            tmp["mac"] = v["bssid"]:toHex()
            tmp["rssi"] = v["rssi"]
            table.insert(query["wifiinfo"], tmp)
        end
    end

    local rheaders = {}
    rheaders["Content-Type"] = "application/json"

    local rbody = (json.encode(query))
    -- log.info("请求的内容", rbody)
    -- sys.taskInit(function()
        -- log.info("执行查询")
        local code, headers, body = http.request("POST", "https://apis.map.qq.com/ws/location/v1/network", rheaders, (json.encode(query))).wait()
        if code == 200 and body and #body > 10 then
            -- log.info("wifiloc", "查询成功", body)
            local tmp = json.decode(body)
            if tmp and tmp.status and 0 == tmp.status then
                return tmp.result
            end
        else
            log.info("qqlbs", "查询失败", code, body)
            return
        end
    -- end)
end

return qqlbs
