float   PI = 3.14159

int EXPONENTIAL =   1
int SIGMOID     =   2
int LINOID      =   3

// soma parameters
float EREST_ACT = -0.03 // dark potential -30mV
float Rm = 0.06		// specific membrane resistance (ohms m^2)
float Cm = 0.01			// membrane capacitance (farads/m2)
float Ra = 0.02			// specific axial resistance (ohms m)

// cell dimensions (meters)
float soma_l = 8e-6            // 8 um diameter
float soma_d = 100e-6           // 100 um length
float SOMA_A = soma_l*PI*soma_d //  soma area


//LEAK
float Eleak = -0.074  //V
float Gleak = 0.052e-6 //S


//h Channel
float Eh = -0.032 //V
float Gh_max = 2.5e-9 //S
float H_channel_Xpower = 1.0
float H_channel_Ypower = 0.0

int H_channel_X_alpha_FORM	= EXPONENTIAL
float H_channel_X_alpha_A = 1  //1/s
float H_channel_X_alpha_B = -0.0106 //v
float H_channel_X_alpha_V0 = -0.075  //v
int H_channel_X_beta_FORM	= EXPONENTIAL
float H_channel_X_beta_A = H_channel_X_alpha_A
float H_channel_X_beta_B = -H_channel_X_alpha_B
float H_channel_X_beta_V0 = H_channel_X_alpha_V0


//Ca Channel
float Eca = 0.04 //V
float Gca_max = 4e-6 //S

float Ca_channel_Xpower = 1.0
float Ca_channel_Ypower = 1.0

int Ca_channel_X_alpha_FORM	= EXPONENTIAL
float Ca_channel_X_alpha_A = 100   //1/s
float Ca_channel_X_alpha_B = 0.012 //V
float Ca_channel_X_alpha_V0 = -0.010  //V
int Ca_channel_X_beta_FORM	= EXPONENTIAL
float Ca_channel_X_beta_A = Ca_channel_X_alpha_A
float Ca_channel_X_beta_B = -Ca_channel_X_alpha_B
float Ca_channel_X_beta_V0 = Ca_channel_X_alpha_V0

int Ca_channel_Y_alpha_FORM	= EXPONENTIAL
float Ca_channel_Y_alpha_A = 10  //1/s
float Ca_channel_Y_alpha_B = 0.018 //v
float Ca_channel_Y_alpha_V0 = 0.011  //v
int Ca_channel_Y_beta_FORM	= EXPONENTIAL
float Ca_channel_Y_beta_A = 0.5 //1/s
float Ca_channel_Y_beta_B = -Ca_channel_Y_alpha_B
float Ca_channel_Y_beta_V0 = Ca_channel_Y_alpha_V0



//Kx Channel
float Ekx = -0.074 //V
float Gkx_max = 1.04e-6 //S

float Kx_channel_Xpower = 1.0
float Kx_channel_Ypower = 0.0

int Kx_channel_X_alpha_FORM	= EXPONENTIAL
float Kx_channel_X_alpha_A = 0.66   //1/s
float Kx_channel_X_alpha_B = 0.0114 //V
float Kx_channel_X_alpha_V0 = -0.050  //V
int Kx_channel_X_beta_FORM	= EXPONENTIAL
float Kx_channel_X_beta_A = Kx_channel_X_alpha_A
float Kx_channel_X_beta_B = -Kx_channel_X_alpha_B
float Kx_channel_X_beta_V0 = Kx_channel_X_alpha_V0



//Kv Channel
// from IONIC CURRENT MODEL OF THE VERTEBRATE ROD PHOTORECEPTOR

float Ekv = -0.080 //V
float Gkv_max = 2e-6 //S


float Kv_channel_Xpower = 3.0
float Kv_channel_Ypower = 1.0

int Kv_channel_X_alpha_FORM	= LINOID
float Kv_channel_X_alpha_A = 5   //1/s
float Kv_channel_X_alpha_B = 0.042 //V
float Kv_channel_X_alpha_V0 = 0.100  //V
int Kv_channel_X_beta_FORM	= EXPONENTIAL
float Kv_channel_X_beta_A = 9
float Kv_channel_X_beta_B = -0.040
float Kv_channel_X_beta_V0 = -0.020

int Kv_channel_Y_alpha_FORM	= EXPONENTIAL
float Kv_channel_Y_alpha_A = 0.15   //1/s
float Kv_channel_Y_alpha_B = -0.022 //V
float Kv_channel_Y_alpha_V0 = 0 //V
int Kv_channel_Y_beta_FORM	= SIGMOID
float Kv_channel_Y_beta_A = 0.4135
float Kv_channel_Y_beta_B = 0.007
float Kv_channel_Y_beta_V0 =0.010
