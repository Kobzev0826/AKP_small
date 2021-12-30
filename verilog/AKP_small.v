module AKP_small(
input wire	clk,
input wire	clk_akp,
input wire	data_en,
input wire	sbros,
input wire	ink_i,
input wire	[1:0] CLCCODE,
input wire	[31:0] Constant_for_KSI,
input wire	[31:0] KOMP_1_IM,
input wire	[31:0] KOMP_1_RE,
input wire	[31:0] KOMP_2_IM,
input wire	[31:0] KOMP_2_RE,
input wire	[11:0] L_stroke,
input wire	[31:0] OBZ_DN_IM,
input wire	[31:0] OBZ_DN_RE,
input wire	[31:0] OBZ_UP_IM,
input wire	[31:0] OBZ_UP_RE,
input wire	[31:0] PEL_IM,
input wire	[31:0] PEL_RE,
output wire	AKP_fifo_gen_empty,
output reg	ink_out,
output reg	data_valid,
output reg	sop,
output reg	eop,

output wire	[191:0] dout,
output wire	[11:0] L_stroke_1
);




wire	[31:0] AKP_k1_fifo,AKP_upobz_fifo;
wire			clr;
wire			nclr;
reg				clr_f,clr_ff;
wire			d_valid;

reg				first_in;

reg				ink;
wire			ink_1f;

wire	[31:0] 	KSI_ksi1_, KSI_ksi2_;
wire	[11:0] 	L_stroke_wire;
wire			loop;


reg		[31:0] 	PEL_OUT_IM;
reg		[31:0] 	PEL_OUT_RE;
reg				read_fifo_main;
reg				read_fifo_main_f;

wire			sbros_n;
wire			string_new;
wire			strobe_first;
wire			strobe_ink;

reg		[31:0] 	U_OUT_DN_IM;
reg		[31:0] 	U_OUT_DN_RE;
reg		[31:0] 	U_OUT_UP_IM;
reg		[31:0] 	U_OUT_UP_RE;
reg				work;

wire	[31:0] 	U_AUX1_IM;
wire	[31:0] 	U_AUX2_IM;
wire	[31:0] 	U_AUX2_RE;
wire	[31:0] 	U_MAIN_IM;
wire			eop_strob;

wire	[15:0] 	ksi_counter;
wire			ksi_en;
reg				ksi_en_f;
reg				ksi_en_fff;
reg				ksi_en_ffff;
reg				ksi_en_fffff;
reg				ksi_en_ffffff;

wire	[31:0] 	U_OUT_RE;
wire	[31:0] 	U_OUT_IM;
wire	[31:0] 	U_OUT_RE_DN;
wire	[31:0] 	U_OUT_IM_DN;

reg				ink_1f_ft;
reg				read_fifo_main_ff;

wire	[31:0] 	U_MAIN_IM_DN;
wire	[31:0] 	U_MAIN_RE_DN;

wire			shiftout;
reg				shiftout_ft;

wire	[31:0] 	PEL_OUT_RE_delay,PEL_OUT_IM_delay;
reg		[31:0] 	PEL_OUT_RE_delay_f,PEL_OUT_IM_delay_f;

reg				ksi_en_ff;
reg				eop_strob_f, eop_strob_ff;

wire	[191:0] GDFX_TEMP_SIGNAL_0;
wire	[15:0] GDFX_TEMP_SIGNAL_1;


assign	GDFX_TEMP_SIGNAL_0 = {U_OUT_UP_RE[31:0],U_OUT_UP_IM[31:0],U_OUT_DN_RE[31:0],U_OUT_DN_IM[31:0],PEL_OUT_RE[31:0],PEL_OUT_IM[31:0]};
assign	GDFX_TEMP_SIGNAL_1 = {4'd0,L_stroke_wire[11:0]};
assign	nclr =  ~clr;
assign	clr = ink_i;
assign	eop_strob = ~ksi_en & work & eop_reg;
assign	dout = GDFX_TEMP_SIGNAL_0;
assign	sbros_n =  ~sbros;
assign	string_new = shiftout & (~shiftout_ft);
assign	L_stroke_1 = L_stroke_wire;
assign	loop = 1;

//сдвиг ink
always@(posedge clk)
begin begin
		clr_f <= clr;
		clr_ff <= clr_f;
		ink <= clr_ff;
	end
end

always@(posedge clk or negedge nclr)
begin
if (!nclr)
	begin
	read_fifo_main <= 0;
	end
else
	begin
	read_fifo_main <= ~read_fifo_main & ksi_en | read_fifo_main & ~eop_strob;
	read_fifo_main_f <= read_fifo_main;
	
	if (GDFX_TEMP_SIGNAL_1 == ksi_counter ) eop_reg<=1'b1;
	else eop_reg <= 1'b0;
	end
end

always@(posedge clk)
begin
	
	eop_strob_f <= eop_strob;
	eop_strob_ff <= eop_strob_f;
	eop <= eop_strob_ff;

	ksi_en_f <= ksi_en;
	ksi_en_ff <= ksi_en_f;
	ksi_en_fff <= ksi_en_ff;
	ksi_en_ffff <= ksi_en_fff;
	ksi_en_fffff <= ksi_en_ffff;
	ksi_en_ffffff <= ksi_en_fffff;
	first_in <= ksi_en_ffffff;
	
	ink_1f_ft <= ink_1f;
	ink_out <= ink_1f_ft;
	
	sop <= ksi_en_fff;
	
	read_fifo_main_ff <= read_fifo_main_f;
	data_valid <= read_fifo_main_ff;
end


always@(posedge clk)
begin
	begin
	U_OUT_UP_RE[31:0] <= U_OUT_RE[31:0];
	
	U_OUT_UP_IM[31:0] <= U_OUT_IM[31:0];
	
	U_OUT_DN_RE[31:0] <= U_OUT_RE_DN[31:0];
	
	U_OUT_DN_IM[31:0] <= U_OUT_IM_DN[31:0];
	
	PEL_OUT_RE_delay_f[31:0] <= PEL_OUT_RE_delay[31:0];
	
	PEL_OUT_RE[31:0] <= PEL_OUT_RE_delay_f[31:0];
	
	PEL_OUT_IM_delay_f[31:0] <= PEL_OUT_IM_delay[31:0];
	
	PEL_OUT_IM[31:0] <= PEL_OUT_IM_delay_f[31:0];
	end
end

always@(posedge clk or negedge sbros_n)
begin
if (!sbros_n)
	begin
	work <= 0;
	end
else
	begin
	work <= ~work & ink | work & 1b'1;
	end
end

AKP_KSI_counter	AKP_KSI_counter(
	.sset(ksi_en),
	.clock(clk),
	.cnt_en(read_fifo_main),
	.aclr(clr),
	
	.q(ksi_counter)
);


GEN_FIFO	GEN_FIFO(
	.ink(ink),
	.wren(data_en),
	.clk(clk),
	.read_fifo(read_fifo_main),
	.clr(clr),
	.IN1(OBZ_UP_RE),
	.IN2(OBZ_UP_IM),
	.IN3(OBZ_DN_RE),
	.IN4(OBZ_DN_IM),
	.IN5(KOMP_1_RE),
	.IN6(KOMP_1_IM),
	.IN7(KOMP_2_RE),
	.IN8(KOMP_2_IM),
	
	.ink_out(ink_1f),
	.fifo_empty(AKP_fifo_gen_empty),
	.OUT1(AKP_upobz_fifo),
	.OUT2(U_MAIN_IM),
	.OUT3(U_MAIN_RE_DN),
	.OUT4(U_MAIN_IM_DN),
	.OUT5(AKP_k1_fifo),
	.OUT6(U_AUX1_IM),
	.OUT7(U_AUX2_RE),
	.OUT8(U_AUX2_IM)
);

slc	slc_UP(
	.rst(clr),
	.loop(loop),
	.clk(clk_akp),
	.ink(string_new),
	.data_en(read_fifo_main_f),
	.clk_slow(clk),
	.first_in(first_in),
	.CLCODE(CLCCODE),
	.KSI_1(KSI_ksi1_),
	.KSI_2(KSI_ksi2_),
	.L_stroke(L_stroke),
	.U_AUX1_IM(U_AUX1_IM),
	.U_AUX1_RE(AKP_k1_fifo),
	.U_AUX2_IM(U_AUX2_IM),
	.U_AUX2_RE(U_AUX2_RE),
	.U_MAIN_IM(U_MAIN_IM),
	.U_MAIN_RE(AKP_upobz_fifo),
	
	.U_OUT_IM(U_OUT_IM),
	.U_OUT_RE(U_OUT_RE)
	
);

slc	slc_DN(
	.rst(clr),
	.loop(loop),
	.clk(clk_akp),
	.ink(string_new),
	.data_en(read_fifo_main_f),
	.clk_slow(clk),
	.first_in(first_in),
	.CLCODE(CLCCODE),
	.KSI_1(KSI_ksi1_),
	.KSI_2(KSI_ksi2_),
	.L_stroke(L_stroke),
	.U_AUX1_IM(U_AUX1_IM),
	.U_AUX1_RE(AKP_k1_fifo),
	.U_AUX2_IM(U_AUX2_IM),
	.U_AUX2_RE(U_AUX2_RE),
	.U_MAIN_IM(U_MAIN_IM_DN),
	.U_MAIN_RE(U_MAIN_RE_DN),
	
	.U_OUT_IM(U_OUT_IM_DN),
	.U_OUT_RE(U_OUT_RE_DN)
	
);



PELENG_DELAY	PELENG_DELAY(
	.pel_strobe(data_en),
	.read_pel(read_fifo_main),
	.clk(clk),
	.clr(clr),
	.PEL_IN_IM(PEL_IM),
	.PEL_IN_RE(PEL_RE),
	.PEL_OUT_IM(PEL_OUT_IM_delay),
	.PEL_OUT_RE(PEL_OUT_RE_delay)
);



KSI_CALC	KSI_CALC(
	.ink(ink),
	.d_valid(data_en),
	.clk(clk),
	.clr(clr),
	.work(work),
	.FILT_K1_RE(KOMP_1_RE),
	.FILT_K2_RE(KOMP_2_RE),
	.L_stroke(L_stroke),
	
	.ksi_en(ksi_en),
	
	.ksi1_(KSI_ksi1_),
	.ksi2_(KSI_ksi2_),
	.L_stroke_1(L_stroke_wire)
	
);


AKP_shift_reg_en_acc	AKP_shift_reg_en_acc(
	.shiftin(ksi_en_fff),
	.clock(clk_akp),
	.shiftout(shiftout)
);

always@(posedge clk_akp)
begin
	begin
	shiftout_ft <= shiftout;
	end
end

endmodule
