module KSI_CALC #(parameter KSI_const2_param = 32'd 1065353216, AKP_KSI_const1=32'd 1048576000, AKP_KSI_const3=32'd 1128761015) 
(
input wire	clk,
input wire	clr,
input wire	ink,
input wire	d_valid,
input wire	work,
input wire	[31:0] FILT_K1_RE,
input wire	[31:0] FILT_K2_RE,
input wire	[11:0] L_stroke,

output wire	ink2_new,
output wire	fifo2_read,
output wire	start_calc,
output wire	fifo2_read_strob,
output wire	acc2_front_new,
output wire	fifo2_read_f,
output wire	ksi_en,
output wire	[31:0] FILT_K1_RE_shift,
output wire	[31:0] ksi1,
output wire	[31:0] ksi2,
output wire	[11:0] L_stroke_1,
output wire	[31:0] out_acc_first,
output wire	[31:0] out_acc_second,
output wire	[31:0] out_div_first,
output wire	[31:0] out_div_second,
output wire	[31:0] out_mult_first,
output wire	[31:0] out_mult_second,
output wire	[31:0] out_sb_first,
output wire	[31:0] out_sub_second
);


//------------------------------------------------------------------------------
//----------------------БЛОК РАСЧЕТА МАТЕМАТИКА---------------------------------
AKP_KSI_divide	AKP_KSI_divide_01(
	.clock(clk),
	.aclr(clr),
	.dataa(out_acc_first_reg),
	.datab(L_stroke_fp),
	.result(out_div_first_wire)
);
	
AKP_KSI_divide	AKP_KSI_divide_02(
	.clock(clk),
	.aclr(clr),
	.dataa(out_4_acc),
	.datab(L_stroke_fp),
	.result(akp_fp_sub_02_b)
);

AKP_FP_sub	AKP_FP_sub_01(
	.clk(clk),
	.areset(clr),
	.a(FILT_K1_RE_shift_reg),
	.b(out_div_first_wire),
	.q(out_sb_first_wire)
);

AKP_FP_sub	AKP_FP_sub_02(
	.clk(clk),
	.areset(clr),
	.a(FILT_K2_RE_shift),
	.b(akp_fp_sub_02_b),
	.q(akp_ksi_mult_02_ab)
);

AKP_KSI_mult	AKP_KSI_mult_01(
	.clock(clk),
	.aclr(clr),
	.dataa(out_sb_first_wire),
	.datab(out_sb_first_wire),
	.result(out_mult_first_wire)
);


AKP_KSI_mult	AKP_KSI_mult_02(
	.clock(clk),
	.aclr(clr),
	.dataa(akp_ksi_mult_02_ab),
	.datab(akp_ksi_mult_02_ab),
	.result(out_mult_second_wire)
);


AKP_KSI_Acc	AKP_KSI_Acc_01(
	.clk(clk),
	.areset(clr),
	.n(acc2_front_new_reg),
	.en(fifo2_read_f_reg),
	.x(out_mult_first_wire),
	.r(out_acc_second)
);

AKP_KSI_Acc	AKP_KSI_Acc_02(
	.clk(clk),
	.areset(clr),
	.n(acc2_front_new_reg),
	.en(fifo2_read_f_reg),
	.x(out_mult_second_wire),
	.r(akp_ksi_acc_02_out)
);

AKP_KSI_divide	AKP_KSI_divide_03(
	.clock(clk),
	.aclr(clr),
	.dataa(in_div_num),
	.datab(L_strokefp_1),
	.result(out_div_second_wire));


AKP_KSI_divide	AKP_KSI_divide_04(
	.clock(clk),
	.aclr(clr),
	.dataa(in_div_02_num),
	.datab(L_strokefp_1),
	.result(SYNTHESIZED_WIRE_2));

AKP_KSI_mult	AKP_KSI_mult_03(
	.clock(clk),
	.aclr(clr),
	.dataa(out_div_second_wire),
	.datab(AKP_KSI_const1),
	.result(out_mult_second_wire));


AKP_KSI_mult	AKP_KSI_mult_04(
	.clock(clk),
	.aclr(clr),
	.dataa(AKP_KSI_const1),
	.datab(SYNTHESIZED_WIRE_2),
	.result(out_mult_second_02_wire));

AKP_KSI_sub	AKP_KSI_sub_01(
	.clock(clk),
	.dataa(out_mult_second_wire),
	.datab(KSI_const2_param),
	.result(out_sub_second_wire));


AKP_KSI_sub	AKP_KSI_sub_02(
	.clock(clk),
	.dataa(out_mult_second_02_wire),
	.datab(KSI_const2_param),
	.result(out_sub_second_02_wire));

AKP_KSI_divide	AKP_KSI_divide_05(
	.clock(clk),
	.aclr(clr),
	.dataa(KSI_const3),
	.datab(out_sub_second_wire),
	.result(ksi1));

AKP_KSI_divide	AKP_KSI_divide_06(
	.clock(clk),
	.aclr(clr),
	.dataa(KSI_const3),
	.datab(out_sub_second_02_wire),
	.result(ksi2));
	
	
endmodule
