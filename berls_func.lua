--[[
    伯林青　自作スクリプト用関数モジュール | 最終更新 : 2023/12/10
    rikky_moduleを用いたものは除外してます（rikky_moduleはAGPLライセンスらしいのでGPL汚染対策として）
    This scripts are written in Shift-JIS.
]]

----------------------------------------------------------------------------------------------------------------------------------
-- K-meansランダム色ラベル
----------------------------------------------------------------------------------------------------------------------------------
km_rand = function(slider0, exe)
    local ud, w, h = obj.getpixeldata()

    local b = require("beRLF")
    if exe then
        b.KmLabeling(ud, w, h, slider0)
        obj.putpixeldata(ud)
    end
end

----------------------------------------------------------------------------------------------------------------------------------
-- K-means減色
----------------------------------------------------------------------------------------------------------------------------------
km_sub = function(slider0, exe)
    local ud, w, h = obj.getpixeldata()

    local b = require("beRLF")
    if exe then
        b.KmPosterize(ud, w, h, slider0)
        obj.putpixeldata(ud)
    end
end

----------------------------------------------------------------------------------------------------------------------------------
-- DNN超解像
----------------------------------------------------------------------------------------------------------------------------------
dn_sup = function(filename, slider0)
    -- 拡大手法と倍率の設定
    local name = ""
    local path   = string.gsub(filename, "\\", "/")   -- c:/usr/.../aaa/oo_x?.pb
    local tmpA   = string.sub(path, -8)               -- oo_x?.pb
    local method = string.sub(tmpA, 1, 2)             -- oo
    local scale  = tonumber(string.sub(tmpA, 5, 5))

    if (method == "SR") then
        name = "edsr"
    elseif (method == "CN") then
        name = "espcn"
    elseif (method == "NN") or (method == "ll") then
        name = "fsrcnn"
    elseif (method == "RN") then
        name = "lapsrn"
    else
        debug_print("model error")
        return
    end

    if ((type(scale) ~= type(0)) or (scale < 2)) then
        debug_print("scale error")
        return
    end

    -- 拡大後のバッファ領域を確保
    local ud, w, h = obj.getpixeldata("alloc")
    local Wsc, Hsc = 8000, 8000  -- 拡大後画像の大きさの制限。本来はAviutlの最大画像サイズを取得したい
    local top    = math.floor(h * (scale - 1) / 2)
    local bottom = (scale - 1) * h - top
    local left   = math.floor(w * (scale - 1) / 2)
    local right  = (scale - 1) * w - left

    if (w*scale > Wsc) or (h*scale > Hsc)  then
        print("object size is too big !!.")
        return
    elseif (top < 0) or (bottom < 0) or (left < 0) or (right < 0) then
        print("original object size is too small !")
        return
    else
        obj.effect("領域拡張", "上", top, "下", bottom, "左", left, "右", right, "塗りつぶし", 0)
    end

    local Sud, Sw, Sh = obj.getpixeldata()

    -- デバッグ用
    -- debug_print("model name : ".. name)
    -- debug_print("model path")
    -- debug_print(path)
    -- debug_print("super resolution scale : ".. scale.. " | typeid : ".. type(scale))
    -- debug_print("original object size [".. w.. " : ".. h.. "]")
    -- debug_print("upscale object size [".. Sw.. " : ".. Sh.. "]")
    -- debug_print("領域拡張 [".. top.. " : ".. bottom.. " : ".. left.. " : ".. right.. "]")
    -- debug_print("---------------------------------------------------\n")

    -- 実行
    local b = require("beRLF")
    b.superres(Sud, Sw, Sh, ud, top, left, name, path, scale, slider0)
    obj.putpixeldata(Sud)
end

----------------------------------------------------------------------------------------------------------------------------------
-- color_separate_pixel
----------------------------------------------------------------------------------------------------------------------------------
px_spr = function(slider0,slider1,slider2,frame_chenge,w_interval,h_interval,col_select,rand_col,alpha,luminance,square)
    local colour2 = function(ri,rj,rw,rh)
        local HSB_
        local seed = slider2*( math.floor( ri/(rw/slider0)/w_interval ) + math.floor( rj/(rh/slider1)/h_interval )*rw+1 )

        if(rand_col) then	
            HSB_ = HSV( math.floor(obj.rand(0,255,seed,frame_chenge)), math.floor(obj.rand(0,100,seed,frame_chenge)), math.floor(obj.rand(0,100,seed,frame_chenge)) )
        else
            local rand_select = obj.rand(1,#col_select,seed,frame_chenge)
            HSB_ = col_select[rand_select]
        end
        return HSB_
    end

    local ffi=require("ffi")
    ffi.cdef[[ typedef struct { uint8_t b,g,r,a; } PixelBGRA; ]]

    local ud,w,h = obj.getpixeldata()
    local cd=ffi.cast("PixelBGRA*",ud)

    w,h=w*obj.getvalue("zoom")/100,h*obj.getvalue("zoom")/100
    slider1 = (square) and math.floor(slider0*h/w) or slider1

    -- 出力
    for y=0,h-1 do 
        for x=0,w-1 do
            local p=cd[x+y*w]

                p.r,p.g,p.b=RGB(colour2(x,y,w,h))
                if(alpha) then 
                    if(p.a==0) then
                        p.a=0
                    else
                        p.a=obj.rand(0,255,slider2*( math.floor( x/(w/slider0)/w_interval ) + math.floor( y/(h/slider1)/h_interval )*h+1 ),frame_chenge)
                    end

                end
        end
    end
    obj.putpixeldata(ud)

    -- 透明度適用
    if(luminance) then
        obj.effect("単色化","強さ",100,"輝度を保持する",1,"color",col_select[1])
    end
end

----------------------------------------------------------------------------------------------------------------------------------
-- ease_rand_move
----------------------------------------------------------------------------------------------------------------------------------
es_mv = function(slider0,slider1,slider2,slider3, t, enum, mark, pos)
    local x1,x2 = pos[1], pos[3]
    local y1,y2 = pos[2], pos[4]

    local ease=require("ease")

    local base = 100000
    for j=0,math.floor(slider2) do
        local xc, yc = ease[1](j/100,x1,x2), ease[enum](j/100,y1,y2)

        for i=1, slider0 do
            x = xc + slider1*obj.rand(-base,base,i*slider3+j,t)/(2*base)
            y = yc + slider1*obj.rand(-base,base,i*slider3+j+1,t)/(2*base)
            obj.draw(x,y)
        end
    end

    if mark then
        obj.load("figure","円",0xff0000,40)
        obj.draw(x1,y1)
        obj.load("figure","円",0x0000ff,40)
        obj.draw(x2,y2)
    end
end

----------------------------------------------------------------------------------------------------------------------------------
-- dither
----------------------------------------------------------------------------------------------------------------------------------
by_dtr = function(slider0, slider1, slider2, slider3, switch0, reduced, map, custom, coef, transpose)
    -- 閾値マップ
    local M  = {}
    local Ma = {}

    for i=1,2^slider3,1 do
        M[i]={}
        Ma[i]={}
        
        for j=1,2^slider3,1 do
            Ma[i][j]=0
        end
    end

    for n=1,slider3 do
        for i=1,2^n,1 do
            for j=1,2^n,1 do
                
                if(i<=2^(n-1)) then
                    if(j<=2^(n-1)) then
                        M[i][j]=4*Ma[i][j]
                    else
                        M[i][j]=Ma[i][j-2^(n-1)]+2
                    end
                
                else
                    if(j<=2^(n-1)) then
                        M[i][j]=Ma[i-2^(n-1)][j]+3
                    else
                        M[i][j]=Ma[i-2^(n-1)][j-2^(n-1)]+1
                    end
                end
            
                Ma[i][j]=M[i][j]
            end
        end
    end

    if(switch0) then
        debug_print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n")
        debug_print("しきい値マップ\n")
        if(map) then
            for i=1,#custom do
                for j=1,#custom[i] do
                    debug_print("閾値マップの".." ("..i..","..j..") 番目の要素 : "..custom[i][j])
                end
                debug_print("-----------------------------------------------------------\n")
            end
            debug_print("係数:"..coef)
        else
            for i=1,2^slider3 do
                for j=1,2^slider3 do
                    debug_print("閾値マップの".." ("..i..","..j..") 番目の要素 : "..M[i][j])
                end
                debug_print("-----------------------------------------------------------\n")
            end
            debug_print("係数:(2n)^2="..(2^slider3)^2)
        end
    end

    local ffi=require("ffi")
    ffi.cdef[[
        typedef struct { uint8_t b,g,r,a; } PixelBGRA;
    ]]

    local ub,w,h=obj.getpixeldata()
    local cd=ffi.cast("PixelBGRA*",ub)

    for y=0,h-1 do
        for x=0,w-1 do
            local p=cd[x+y*w]
            local bgra
            
            local bb=math.floor(p.b/(256/slider2))*256/slider2
            local gb=math.floor(p.g/(256/slider1))*256/slider1
            local rb=math.floor(p.r/(256/slider0))*256/slider0
            
            if(map) then
                bgra=math.floor(255*(custom[y%#custom+1][x%#custom[y%#custom+1]+1]))/coef
            else
                if(transpose) then
                    bgra=math.floor(255*(M[x%(2^slider3)+1][y%(2^slider3)+1]+1)/((2^slider3)^2))
                else
                    bgra=math.floor(255*(M[y%(2^slider3)+1][x%(2^slider3)+1]+1)/((2^slider3)^2))
                end
            end

            if(reduced) then
                p.b=bb
                p.g=gb
                p.r=rb
            else
                p.b=(bb>bgra) and 255 or 0
                p.g=(gb>bgra) and 255 or 0
                p.r=(rb>bgra) and 255 or 0
            end
        end
    end
    obj.putpixeldata(ub)
end

----------------------------------------------------------------------------------------------------------------------------------
-- グリッチ風画像
----------------------------------------------------------------------------------------------------------------------------------
im_glc = function(slider0,slider1,slider2,slider3,switch0,color)
    local st,ed=10,200
    local zx,zy=10,20
    local w,h=60,20
    local ffi=require("ffi")

    obj.setoption("dst","tmp",w,h)
    obj.copybuffer("obj","tmp")

    local ud,_,_=obj.getpixeldata()
    local cd=ffi.cast("uint8_t*",ud)

    local size=w*h

    if(switch0) then
        ffi.fill(cd+st*obj.rand(0,math.floor(4.8*slider0),slider2,slider3),(ed-st)*obj.rand(0,math.floor(0.3*slider1),slider2+1,slider3),0xff)
    else
        ffi.fill(cd+st*math.floor(4.8*slider0*slider3/100),(ed-st)*math.floor(0.3*slider1*slider3/100),0xff)
    end

    obj.putpixeldata(ud)

    obj.effect("リサイズ","X",zx*100,"Y",zy*100,"補間なし",1)
    obj.effect("単色化","強さ",100,"輝度を保持する",0,"color",color)
end

----------------------------------------------------------------------------------------------------------------------------------
-- 方向ブラー
----------------------------------------------------------------------------------------------------------------------------------
dr_blr = function(slider0,slider1,slider2,switch0)
    if not switch0 then
        plus = math.floor(slider1/2)
        obj.effect("領域拡張", "上", plus, "下", plus, "左", plus, "右", plus, "塗りつぶし", 0)
    end
    local ud, w, h = obj.getpixeldata()

    -- 実行
    local b = require("beRLF")
    b.directblur(ud, w, h, slider0,slider1,slider2)
    obj.putpixeldata(ud)
end
