--[[
    利用方法 ~ rikky_moduleの使い方 ~ より抜粋

	image関数
	オブジェクトの画像データを一時保存できます
	第1引数で指定する文字列によって、書き、読み、消し、ID検索などが決定します
	第1引数の文字列
	"w"  : オブジェクトイメージをメモリに書き込みます
	       boolean = rikky_module.image("w", string or number [, string])
	       書き込みたいIDを文字列か数値で指定します
	       第3引数に"tempbuffer"を指定すると、仮想バッファのイメージを保存できます
	       成功するとtrue、失敗するとfalseのブ―リアンを返します

	"w+" : オブジェクトイメージをメモリに書き込みます
	       boolean = rikky_module.image("w+", string or number)
	       書き込みたいIDを文字列か数値で指定します
	       透明度やobj.alphaの数値をイメージのアルファ値に乗算します
	       成功するとtrue、失敗するとfalseのブ―リアンを返します

	"r"  : メモリ上にある書き込んだオブジェクトイメージを呼び出します
	       boolean = rikky_module.image("r", string or number)
	       呼び出したいIDを文字列か数値で指定します
	       成功するとtrue、失敗するとfalseのブ―リアンを返します
	       新しく呼び出しているのでobj.oxなどの値は初期化されます

	"r+" : メモリ上にある書き込んだオブジェクトイメージを呼び出します
	       boolean = rikky_module.image("r+", string or number)
	       呼び出したいIDを文字列か数値で指定します
	       成功するとtrue、失敗するとfalseのブ―リアンを返します
	       呼び出す前のobj.oxなどを引き継ぎます

	"c"  : メモリに書き込んだオブジェクトイメージを消去します
	       boolean = rikky_module.image("c", string or number)
	       消去したいIDを文字列か数値で指定します
	       成功するとtrue、失敗するとfalseのブ―リアンを返します

	"c+" : メモリに書き込んだオブジェクトイメージを消去します
	       boolean = rikky_module.image("c+")
	       書き込んだすべてのイメージを消去します
	       成功するとtrue、失敗するとfalseのブ―リアンを返します

	"g"  : 書き込まれていないID番号を取得する
	       number or talbe = rikky_module.image("g" [, number])
	       まだ使われていないIDの数値を返します
	       0以上の数値です
	       第2引数に0より大きい数値を渡すと、その分だけ未使用のID番号をテーブルで返します

	"g+" : 書き込まれているID番号を取得します
	       table = rikky_module.image("g+")
	       既に書き込まれているIDが収められたテーブルを返します

	"m"  : 書き込まれたイメージを合成します
	       userdata, number, number = rikky_module.image("m", string or number, string or number [, number, number])
	       第2引数で背面のイメージIDを指定し、第3引数で前面に来るイメージIDを指定します
	       第4引数はx座標の数値、第5引数y座標の数値を指定します
	       背面イメージの左上が0、0です
	       省略した場合は0、0と同じになります
	       合成結果はイメージのユーザーデータ、横幅の数値、縦幅の数値の3つを返します
	       ただし、合成に失敗した場合はfalseのブ―リアンを返します

	"m+" : 書き込まれたイメージを合成します
	       boolean = rikky_module.image("m+", string or number, string or number [, number, number])
	       合成をして、同時にそのイメージを読み込みます
	       読み込むときは"r+"と同じ処理になります
	       第2引数で背面のイメージIDを指定し、第3引数で前面に来るイメージIDを指定します
	       第4引数はx座標の数値、第5引数y座標の数値を指定します
	       背面イメージの左上が0、0です
	       省略した場合は0、0と同じになります
	       成功するとtrue、失敗するとfalseのブ―リアンを返します

	"i"  : イメージデータ情報を取得します
	       userdata, number, number = rikky_module.image("i", string or number)
	       イメージ情報を取得したいIDを文字列か数値で指定します
	       戻り値はイメージのユーザーデータ、横幅の数値、縦幅の数値の3つを返します

	"i+" : イメージデータ情報を取得します
	       table, number, number = rikky_module.image("i+", string or number)
	       イメージ情報を取得したいIDを文字列か数値で指定します
	       戻り値はイメージのARGBの情報をもったテーブル、横幅の数値、縦幅の数値の3つを返します
	       テーブルのキーはA、R、G、Bの4つで、それぞれ0から255までの数値をピクセルの数だけ持っています

	"p"  : 指定したIDのイメージに別の指定したIDのイメージをコピーします
	       boolean = rikky_module.image("p", string or number, string or number or userdata, [ number, number])
	       第2引数はコピーイメージを置きたいID、第3引数はコピー元のIDを文字列か数値で指定します
	       第3引数をuserdataにした場合は、横幅を第4引数、縦幅を第5引数に渡してください
	       成功するとtrue、失敗するとfalseのブ―リアンを返します

	"p+" : 指定したIDのイメージに別の指定したIDのイメージをコピーします
	       boolean = rikky_module.image("p+", string or number, string or number or userdata, [ number, number])
	       第2引数はコピーイメージを置きたいID、第3引数はコピー元のIDを文字列か数値で指定します
	       第3引数をuserdataにした場合は、横幅を第4引数、縦幅を第5引数に渡してください
	       コピー先に既にイメージがある場合は失敗になります
	       成功するとtrue、失敗するとfalseのブ―リアンを返します

	"u"  : 指定したIDまたは渡したuserdataの指定した位置の色と透明度を取得します
	       number, number = rikky_module.image("u", string or number or userdata, number [, number, number, number])
	       色の数値は0から0xFFFFFF、透明度は0から1です
	       IDを指定した場合とuserdataを指定した場合で引数が変わってきます
	       また取得したい色の位置の指定方法でも引数が変わってきます
	       IDを指定した場合、第3引数または第3引数と第4引数が色の位置を指定する部分になります
	       第3引数のみの場合はその数値の位置の色情報、第4引数も渡すと横と縦の位置の色情報を返すようになります
	       例えば10×10で第3引数のみ99だと右下の色情報、第3引数を10、第4引数を10にすると右下の色情報になります
	       userdataを指定したuserdataの縦幅と横幅を渡す必要があります
	       色の位置を1つの数値だけで指定する場合は第4引数に横幅、第5引数に縦幅の数値を渡します
	       色の位置を縦と横の位置で指定した場合は第5引数に横幅、第6引数に縦幅の数値を渡します

	"u+" : 指定したIDまたは渡したuserdataの指定した位置の色のRとGとBと透明度を取得します
	       number, number, number, number = rikky_module.image("u", string or number or userdata, number [, number, number, number])
	       色の数値はRが0から255、Gが0から255、Bが0から255、透明度は0から255です
	       IDを指定した場合とuserdataを指定した場合で引数が変わってきます
	       また取得したい色の位置の指定方法でも引数が変わってきます
	       IDを指定した場合、第3引数または第3引数と第4引数が色の位置を指定する部分になります
	       第3引数のみの場合はその数値の位置の色情報、第4引数も渡すと横と縦の位置の色情報を返すようになります
	       例えば10×10で第3引数のみ99だと右下の色情報、第3引数を10、第4引数を10にすると右下の色情報になります
	       userdataを指定したuserdataの縦幅と横幅を渡す必要があります
	       色の位置を1つの数値だけで指定する場合は第4引数に横幅、第5引数に縦幅の数値を渡します
	       色の位置を縦と横の位置で指定した場合は第5引数に横幅、第6引数に縦幅の数値を渡します
]]

----------------------------------------------------------------------------------------------------------------------------------
--copybuffer
----------------------------------------------------------------------------------------------------------------------------------
function safe_copybuffer(dst,src)
    -- if not obj.copybuffer(dst,src) then
    --     debug_print(string.format("Failed obj.copybuffer (%s <- %s)",dst,src))
	-- end
	return obj.copybuffer(dst,src)
end

----------------------------------------------------------------------------------------------------------------------------------
--require rikky_module
----------------------------------------------------------------------------------------------------------------------------------
rikky_buffer = rikky_buffer or {}
require("rikky_module")

----------------------------------------------------------------------------------------------------------------------------------
--write image
----------------------------------------------------------------------------------------------------------------------------------
rikky_buffer.write = function(id,tmp)
    tmp=(tmp==true) and "tempbuffer" or nil
    -- if not (rikky_module.image("w",id,tmp)) then
    --     id=tostring(id)
    --     debug_print(string.format("Failed rikky_module.image : write id=%s",id))
	-- end
    return rikky_module.image("w",id,tmp)
end

rikky_buffer.write2 = function(id,tmp)
    -- if not (rikky_module.image("w+",id)) then
    --     id=tostring(id)
    --     debug_print(string.format("Failed rikky_module.image : write+ id=%s",id))
	-- end
    return rikky_module.image("w+",id)
end

----------------------------------------------------------------------------------------------------------------------------------
--read image
----------------------------------------------------------------------------------------------------------------------------------
rikky_buffer.read = function(id)
    -- if not (rikky_module.image("r",id)) then
    --     id=tostring(id)
    --     debug_print(string.format("Failed rikky_module.image : read id=%s",id))
	-- end
	return rikky_module.image("r",id)
end

rikky_buffer.read2 = function(id)
    -- if not (rikky_module.image("r+",id)) then
    --     id=tostring(id)
    --     debug_print(string.format("Failed rikky_module.image : read+ id=%s",id))
	-- end
    return rikky_module.image("r+",id)
end

----------------------------------------------------------------------------------------------------------------------------------
--clean image
----------------------------------------------------------------------------------------------------------------------------------
rikky_buffer.clean = function(id)
    -- if not (rikky_module.image("c",id)) then
    --     id=tostring(id)
    --     debug_print(string.format("Failed rikky_module.image : clean id=%s",id))
	-- end
    return rikky_module.image("c",id)
end

rikky_buffer.clean2 = function()
    -- if not rikky_module.image("c+") then
    --     debug_print("Failed rikky_module.image : clean+")
	-- end
    return rikky_module.image("c+")
end

----------------------------------------------------------------------------------------------------------------------------------
--search id
----------------------------------------------------------------------------------------------------------------------------------
rikky_buffer.freeid = function(range)
    if(range<0) then 
        return rikky_module.image("g")
    else
	    return rikky_module.image("g",range)
    end
end

rikky_buffer.useid = function()
    return rikky_module.image("g+")
end

----------------------------------------------------------------------------------------------------------------------------------
--synthesize image
----------------------------------------------------------------------------------------------------------------------------------
rikky_buffer.synthesize = function(backid,forwardid,x,y)
    -- if not (rikky_module.image("m",backid,forwardid,x,y)) then
    --     backid,forwardid=tostring(backid),tostring(forwardid)
    --     debug_print(string.format("Failed rikky_module.image : synthesize back_id=%s,forward_id=%s",backid,forwardid))
	-- end
        return rikky_module.image("m",backid,forwardid,x,y)
end

rikky_buffer.synthesize2 = function(backid,forwardid,x,y)
    -- if not (rikky_module.image("m+",backid,forwardid,x,y)) then
    --     backid,forwardid=tostring(backid),tostring(forwardid)
    --     debug_print(string.format("Failed rikky_module.image : synthesize+ back_id=%s,forward_id=%s",backid,forwardid))
	-- end
    return rikky_module.image("m+",backid,forwardid,x,y)
end

----------------------------------------------------------------------------------------------------------------------------------
--get imagedata
----------------------------------------------------------------------------------------------------------------------------------
rikky_buffer.get = function(id)
    return rikky_module.image("i",id)
end

rikky_buffer.get2 = function(id)
    return rikky_module.image("i+",id)
end

----------------------------------------------------------------------------------------------------------------------------------
--copy imagedata
----------------------------------------------------------------------------------------------------------------------------------
rikky_buffer.copy = function(dst,src,w,h)
    if(rikky_module.type(src)=="userdata" and (w==nil or h==nil)) then
        -- debug_print("Write [width or height] of object ")
		return false
    else
        -- if not (rikky_module.image("p",dst,src,w,h)) then
        --     dst,forwardid=tostring(dst),tostring(src)
        --     debug_print(string.format("Failed rikky_module.image : copy dst_id=%s <- src_id=%s",dst,src))
		-- end
        return rikky_module.image("p",dst,src,w,h)
    end
end

rikky_buffer.copy2 = function(dst,src,w,h)
    if(rikky_module.type(src)=="userdata" and (w==nil or h==nil)) then
        -- debug_print("Write [width or height] of object ")
		return false
    else
        -- if not (rikky_module.image("p+",dst,src,w,h)) then
        --     dst,forwardid=tostring(dst),tostring(src)
        --     debug_print(string.format("Failed rikky_module.image : copy+ dst_id=%s <- src_id=%s",dst,src))
		-- end
        return rikky_module.image("p+",dst,src,w,h)
    end
end

----------------------------------------------------------------------------------------------------------------------------------
--get color&alpha data
----------------------------------------------------------------------------------------------------------------------------------
rikky_buffer.col = function(id,x_or_index,y_or_w,w_or_h,h)
    return rikky_module.image("u",id,x_or_index,y_or_w,w_or_h,h)
end

rikky_buffer.col = function(id,x_or_index,y_or_w,w_or_h,h)
    return rikky_module.image("u+",id,x_or_index,y_or_w,w_or_h,h)
end


----------------------------------------------------------------------------------------------------------------------------------
--追加でextbuffer.readを再現した
----------------------------------------------------------------------------------------------------------------------------------
rikky_buffer.read3 = function(id,alpha)
	if (alpha) then
		rikky_buffer.read2(id)
	else
		rikky_buffer.read(id)
	end

	local user,wb,hb=rikky_buffer.get(id)
	obj.putpixeldata(user)
	user,wb,hb=nil,nil,nil
end