
function make_H_channel_hh
	if ({exists H_channel_hh})
		return
	end

	create		hh_channel	H_channel_hh
  setfield H_channel_hh \
		Ek            {Eh} \				// V
		Gbar		      {Gh_max} \		// S
		Xpower		    {H_channel_Xpower}\
		Ypower        {H_channel_Ypower} \
		X_alpha_FORM  {H_channel_X_alpha_FORM} \
		X_alpha_A	    {H_channel_X_alpha_A}\			// 1/V-sec
		X_alpha_B   	{H_channel_X_alpha_B}\			// V
		X_alpha_V0    {H_channel_X_alpha_V0} \		// V
		X_beta_FORM   {H_channel_X_beta_FORM} \
		X_beta_A      {H_channel_X_beta_A}\				// 1/sec
		X_beta_B      {H_channel_X_beta_B} \			// V
		X_beta_V0     {H_channel_X_beta_V0}  		// V
end


function make_Ca_channel_hh
	if ({exists Ca_channel_hh})
		return
	end

	create		hh_channel	Ca_channel_hh
  setfield Ca_channel_hh \
		Ek            {Eca} \				// V
		Gbar		      {Gca_max} \		// S
		Xpower		    {Ca_channel_Xpower}\
		Ypower        {Ca_channel_Ypower} \
		X_alpha_FORM  {Ca_channel_X_alpha_FORM} \
		X_alpha_A	    {Ca_channel_X_alpha_A}\			// 1/V-sec
		X_alpha_B   	{Ca_channel_X_alpha_B}\			// V
		X_alpha_V0    {Ca_channel_X_alpha_V0} \		// V
		X_beta_FORM   {Ca_channel_X_beta_FORM} \
		X_beta_A      {Ca_channel_X_beta_A}\				// 1/sec
		X_beta_B      {Ca_channel_X_beta_B} \			// V
		X_beta_V0     {Ca_channel_X_beta_V0}  \		// V
    Y_alpha_FORM  {Ca_channel_Y_alpha_FORM} \
		Y_alpha_A	    {Ca_channel_Y_alpha_A}\			// 1/V-sec
		Y_alpha_B   	{Ca_channel_Y_alpha_B}\			// V
		Y_alpha_V0    {Ca_channel_Y_alpha_V0} \		// V
		Y_beta_FORM   {Ca_channel_Y_beta_FORM} \
		Y_beta_A      {Ca_channel_Y_beta_A}\				// 1/sec
		Y_beta_B      {Ca_channel_Y_beta_B} \			// V
		Y_beta_V0     {Ca_channel_Y_beta_V0}  		// V

end

function make_Kx_channel_hh
	if ({exists Kx_channel_hh})
		return
	end

	create		hh_channel	Kx_channel_hh
  setfield Kx_channel_hh \
		Ek            {Ekx} \				// V
		Gbar		      {Gkx_max} \		// S
		Xpower		    {Kx_channel_Xpower}\
		Ypower        {Kx_channel_Ypower} \
		X_alpha_FORM  {Kx_channel_X_alpha_FORM} \
		X_alpha_A	    {Kx_channel_X_alpha_A}\			// 1/V-sec
		X_alpha_B   	{Kx_channel_X_alpha_B}\			// V
		X_alpha_V0    {Kx_channel_X_alpha_V0} \		// V
		X_beta_FORM   {Kx_channel_X_beta_FORM} \
		X_beta_A      {Kx_channel_X_beta_A}\				// 1/sec
		X_beta_B      {Kx_channel_X_beta_B} \			// V
		X_beta_V0     {Kx_channel_X_beta_V0}  		// V
end

function make_Kv_channel_hh
	if ({exists Kv_channel_hh})
		return
	end

	create		hh_channel	Kv_channel_hh
  setfield Kv_channel_hh \
		Ek            {Ekv} \				// V
		Gbar		      {Gkv_max} \		// S
		Xpower		    {Kv_channel_Xpower}\
		Ypower        {Kv_channel_Ypower} \
		X_alpha_FORM  {Kv_channel_X_alpha_FORM} \
		X_alpha_A	    {Kv_channel_X_alpha_A}\			// 1/V-sec
		X_alpha_B   	{Kv_channel_X_alpha_B}\			// V
		X_alpha_V0    {Kv_channel_X_alpha_V0} \		// V
		X_beta_FORM   {Kv_channel_X_beta_FORM} \
		X_beta_A      {Kv_channel_X_beta_A}\				// 1/sec
		X_beta_B      {Kv_channel_X_beta_B} \			// V
		X_beta_V0     {Kv_channel_X_beta_V0} \ 		// V
    Y_alpha_FORM  {Kv_channel_Y_alpha_FORM} \
    Y_alpha_A	    {Kv_channel_Y_alpha_A}\			// 1/V-sec
    Y_alpha_B   	{Kv_channel_Y_alpha_B}\			// V
    Y_alpha_V0    {Kv_channel_Y_alpha_V0} \		// V
    Y_beta_FORM   {Kv_channel_Y_beta_FORM} \
    Y_beta_A      {Kv_channel_Y_beta_A}\				// 1/sec
    Y_beta_B      {Kv_channel_Y_beta_B} \			// V
    Y_beta_V0     {Kv_channel_Y_beta_V0}  		// V
end
