
local demo = {}


-- 提醒: 
-- 腾讯的定位服务需要收费, 具体请咨询腾讯. 2024.1.3咨询的答复的免费额度是10000次/天,并发5次/秒.
-- 腾讯的定位服务需要一个key, 登陆 lbs.qq.com 注册,并个人认证后可用, 企业认证的额度一样
-- 返回结果的坐标系是GCJ02

qqlbs = require "qqlbs"

sys.taskInit(function()
    -- 如果是4G模块又打算使用wifi定位,加这句
    if mobile and wlan then
        wlan.init()
    end
    sys.waitUntil("net_ready")
    sys.wait(1000)

    -- https://lbs.qq.com/dev/console/application/mine
    local qqkey = "" -- 替换成你自己的key

    while 1 do
        -- 有没有基站信息呢? 可选
        if mobile then
            log.info("qqlbs", "开始获取基站信息")
            mobile.reqCellInfo(15)
            sys.waitUntil("CELL_INFO_UPDATE", 3000)
        else
            log.info("qqlbs", "当前模块不支持查询基站信息")
        end

        -- 有没有wifi信息呢? 可选
        if wlan then
            log.info("qqlbs", "开始获取wifi信息")
            wlan.scan()
            sys.waitUntil("WLAN_SCAN_DONE",60000)
        else
            log.info("qqlbs", "当前模块不支持查询wifi信息")
        end

        -- TODO: 获取蓝牙信息,当前不支持 -- 主要是懒
        
        local resp = qqlbs.req(qqkey)
        if resp then
            log.info("qqlbs", "定位成功!!!", json.encode(resp))
        else
            log.info("qqlbs", "定位失败!!!")
        end
        sys.wait(60 * 1000)
    end
end)


return demo
