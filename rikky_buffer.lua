--[[
    ���p���@ ~ rikky_module�̎g���� ~ ��蔲��

	image�֐�
	�I�u�W�F�N�g�̉摜�f�[�^���ꎞ�ۑ��ł��܂�
	��1�����Ŏw�肷�镶����ɂ���āA�����A�ǂ݁A�����AID�����Ȃǂ����肵�܂�
	��1�����̕�����
	"w"  : �I�u�W�F�N�g�C���[�W���������ɏ������݂܂�
	       boolean = rikky_module.image("w", string or number [, string])
	       �������݂���ID�𕶎��񂩐��l�Ŏw�肵�܂�
	       ��3������"tempbuffer"���w�肷��ƁA���z�o�b�t�@�̃C���[�W��ۑ��ł��܂�
	       ���������true�A���s�����false�̃u�\���A����Ԃ��܂�

	"w+" : �I�u�W�F�N�g�C���[�W���������ɏ������݂܂�
	       boolean = rikky_module.image("w+", string or number)
	       �������݂���ID�𕶎��񂩐��l�Ŏw�肵�܂�
	       �����x��obj.alpha�̐��l���C���[�W�̃A���t�@�l�ɏ�Z���܂�
	       ���������true�A���s�����false�̃u�\���A����Ԃ��܂�

	"r"  : ��������ɂ��鏑�����񂾃I�u�W�F�N�g�C���[�W���Ăяo���܂�
	       boolean = rikky_module.image("r", string or number)
	       �Ăяo������ID�𕶎��񂩐��l�Ŏw�肵�܂�
	       ���������true�A���s�����false�̃u�\���A����Ԃ��܂�
	       �V�����Ăяo���Ă���̂�obj.ox�Ȃǂ̒l�͏���������܂�

	"r+" : ��������ɂ��鏑�����񂾃I�u�W�F�N�g�C���[�W���Ăяo���܂�
	       boolean = rikky_module.image("r+", string or number)
	       �Ăяo������ID�𕶎��񂩐��l�Ŏw�肵�܂�
	       ���������true�A���s�����false�̃u�\���A����Ԃ��܂�
	       �Ăяo���O��obj.ox�Ȃǂ������p���܂�

	"c"  : �������ɏ������񂾃I�u�W�F�N�g�C���[�W���������܂�
	       boolean = rikky_module.image("c", string or number)
	       ����������ID�𕶎��񂩐��l�Ŏw�肵�܂�
	       ���������true�A���s�����false�̃u�\���A����Ԃ��܂�

	"c+" : �������ɏ������񂾃I�u�W�F�N�g�C���[�W���������܂�
	       boolean = rikky_module.image("c+")
	       �������񂾂��ׂẴC���[�W���������܂�
	       ���������true�A���s�����false�̃u�\���A����Ԃ��܂�

	"g"  : �������܂�Ă��Ȃ�ID�ԍ����擾����
	       number or talbe = rikky_module.image("g" [, number])
	       �܂��g���Ă��Ȃ�ID�̐��l��Ԃ��܂�
	       0�ȏ�̐��l�ł�
	       ��2������0���傫�����l��n���ƁA���̕��������g�p��ID�ԍ����e�[�u���ŕԂ��܂�

	"g+" : �������܂�Ă���ID�ԍ����擾���܂�
	       table = rikky_module.image("g+")
	       ���ɏ������܂�Ă���ID�����߂�ꂽ�e�[�u����Ԃ��܂�

	"m"  : �������܂ꂽ�C���[�W���������܂�
	       userdata, number, number = rikky_module.image("m", string or number, string or number [, number, number])
	       ��2�����Ŕw�ʂ̃C���[�WID���w�肵�A��3�����őO�ʂɗ���C���[�WID���w�肵�܂�
	       ��4������x���W�̐��l�A��5����y���W�̐��l���w�肵�܂�
	       �w�ʃC���[�W�̍��オ0�A0�ł�
	       �ȗ������ꍇ��0�A0�Ɠ����ɂȂ�܂�
	       �������ʂ̓C���[�W�̃��[�U�[�f�[�^�A�����̐��l�A�c���̐��l��3��Ԃ��܂�
	       �������A�����Ɏ��s�����ꍇ��false�̃u�\���A����Ԃ��܂�

	"m+" : �������܂ꂽ�C���[�W���������܂�
	       boolean = rikky_module.image("m+", string or number, string or number [, number, number])
	       ���������āA�����ɂ��̃C���[�W��ǂݍ��݂܂�
	       �ǂݍ��ނƂ���"r+"�Ɠ��������ɂȂ�܂�
	       ��2�����Ŕw�ʂ̃C���[�WID���w�肵�A��3�����őO�ʂɗ���C���[�WID���w�肵�܂�
	       ��4������x���W�̐��l�A��5����y���W�̐��l���w�肵�܂�
	       �w�ʃC���[�W�̍��オ0�A0�ł�
	       �ȗ������ꍇ��0�A0�Ɠ����ɂȂ�܂�
	       ���������true�A���s�����false�̃u�\���A����Ԃ��܂�

	"i"  : �C���[�W�f�[�^�����擾���܂�
	       userdata, number, number = rikky_module.image("i", string or number)
	       �C���[�W�����擾������ID�𕶎��񂩐��l�Ŏw�肵�܂�
	       �߂�l�̓C���[�W�̃��[�U�[�f�[�^�A�����̐��l�A�c���̐��l��3��Ԃ��܂�

	"i+" : �C���[�W�f�[�^�����擾���܂�
	       table, number, number = rikky_module.image("i+", string or number)
	       �C���[�W�����擾������ID�𕶎��񂩐��l�Ŏw�肵�܂�
	       �߂�l�̓C���[�W��ARGB�̏����������e�[�u���A�����̐��l�A�c���̐��l��3��Ԃ��܂�
	       �e�[�u���̃L�[��A�AR�AG�AB��4�ŁA���ꂼ��0����255�܂ł̐��l���s�N�Z���̐����������Ă��܂�

	"p"  : �w�肵��ID�̃C���[�W�ɕʂ̎w�肵��ID�̃C���[�W���R�s�[���܂�
	       boolean = rikky_module.image("p", string or number, string or number or userdata, [ number, number])
	       ��2�����̓R�s�[�C���[�W��u������ID�A��3�����̓R�s�[����ID�𕶎��񂩐��l�Ŏw�肵�܂�
	       ��3������userdata�ɂ����ꍇ�́A�������4�����A�c�����5�����ɓn���Ă�������
	       ���������true�A���s�����false�̃u�\���A����Ԃ��܂�

	"p+" : �w�肵��ID�̃C���[�W�ɕʂ̎w�肵��ID�̃C���[�W���R�s�[���܂�
	       boolean = rikky_module.image("p+", string or number, string or number or userdata, [ number, number])
	       ��2�����̓R�s�[�C���[�W��u������ID�A��3�����̓R�s�[����ID�𕶎��񂩐��l�Ŏw�肵�܂�
	       ��3������userdata�ɂ����ꍇ�́A�������4�����A�c�����5�����ɓn���Ă�������
	       �R�s�[��Ɋ��ɃC���[�W������ꍇ�͎��s�ɂȂ�܂�
	       ���������true�A���s�����false�̃u�\���A����Ԃ��܂�

	"u"  : �w�肵��ID�܂��͓n����userdata�̎w�肵���ʒu�̐F�Ɠ����x���擾���܂�
	       number, number = rikky_module.image("u", string or number or userdata, number [, number, number, number])
	       �F�̐��l��0����0xFFFFFF�A�����x��0����1�ł�
	       ID���w�肵���ꍇ��userdata���w�肵���ꍇ�ň������ς���Ă��܂�
	       �܂��擾�������F�̈ʒu�̎w����@�ł��������ς���Ă��܂�
	       ID���w�肵���ꍇ�A��3�����܂��͑�3�����Ƒ�4�������F�̈ʒu���w�肷�镔���ɂȂ�܂�
	       ��3�����݂̂̏ꍇ�͂��̐��l�̈ʒu�̐F���A��4�������n���Ɖ��Əc�̈ʒu�̐F����Ԃ��悤�ɂȂ�܂�
	       �Ⴆ��10�~10�ő�3�����̂�99���ƉE���̐F���A��3������10�A��4������10�ɂ���ƉE���̐F���ɂȂ�܂�
	       userdata���w�肵��userdata�̏c���Ɖ�����n���K�v������܂�
	       �F�̈ʒu��1�̐��l�����Ŏw�肷��ꍇ�͑�4�����ɉ����A��5�����ɏc���̐��l��n���܂�
	       �F�̈ʒu���c�Ɖ��̈ʒu�Ŏw�肵���ꍇ�͑�5�����ɉ����A��6�����ɏc���̐��l��n���܂�

	"u+" : �w�肵��ID�܂��͓n����userdata�̎w�肵���ʒu�̐F��R��G��B�Ɠ����x���擾���܂�
	       number, number, number, number = rikky_module.image("u", string or number or userdata, number [, number, number, number])
	       �F�̐��l��R��0����255�AG��0����255�AB��0����255�A�����x��0����255�ł�
	       ID���w�肵���ꍇ��userdata���w�肵���ꍇ�ň������ς���Ă��܂�
	       �܂��擾�������F�̈ʒu�̎w����@�ł��������ς���Ă��܂�
	       ID���w�肵���ꍇ�A��3�����܂��͑�3�����Ƒ�4�������F�̈ʒu���w�肷�镔���ɂȂ�܂�
	       ��3�����݂̂̏ꍇ�͂��̐��l�̈ʒu�̐F���A��4�������n���Ɖ��Əc�̈ʒu�̐F����Ԃ��悤�ɂȂ�܂�
	       �Ⴆ��10�~10�ő�3�����̂�99���ƉE���̐F���A��3������10�A��4������10�ɂ���ƉE���̐F���ɂȂ�܂�
	       userdata���w�肵��userdata�̏c���Ɖ�����n���K�v������܂�
	       �F�̈ʒu��1�̐��l�����Ŏw�肷��ꍇ�͑�4�����ɉ����A��5�����ɏc���̐��l��n���܂�
	       �F�̈ʒu���c�Ɖ��̈ʒu�Ŏw�肵���ꍇ�͑�5�����ɉ����A��6�����ɏc���̐��l��n���܂�
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
--�ǉ���extbuffer.read���Č�����
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