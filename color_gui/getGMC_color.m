function out = getGMC_color()
% Script to return (synthesize) a perfect X-Rite Color Checker Chart
% from the X-Rite supplied sRGB values.

format longG;
format compact;

chipNames = {
'Dark Skin';
'Light Skin';
'Blue Sky';
'Foliage';
'Blue Flower';
'Bluish Green';
'Orange';
'Purple Red';
'Moderate Red';
'Purple';
'Yellow Green';
'Orange Yellow';
'Blue';
'Green';
'Red';
'Yellow';
'Magenta';
'Cyan';
'White';
'Neutral 8';
'Neutral 65';
'Neutral 5';
'Neutral 35';
'Black'};

sRGB_Values = uint32([...
115,82,68
194,150,130
98,122,157
87,108,67
133,128,177
103,189,170
214,126,44
80,91,166
193,90,99
94,60,108
157,188,64
224,163,46
56,61,150
70,148,73
175,54,60
231,199,31
187,86,149
8,133,161
243,243,242
200,200,200
160,160,160
122,122,121
85,85,85
52,52,52]);

RGB_Adobe = uint32([...
107,82,70
184,146,129
101,122,153
95,107,69
128,127,173
129,188,171
201,123,56
77,92,166
174,83,97
86,61,104
167,188,75
213,160,55
49,65,143
99,148,80
155,52,59
227,197,52
169,85,147
61,135,167
245,245,242
200,201,201
160,161,162
120,120,121
84,85,86
52,53,54]);

gray_Values = 256 * uint16([...
243
200
160
122
85
52]);

%illuminant L=100; a=0; b=0;
Lab_CIE_D50 = [ ...
37.99,  13.56,  14.06  
65.71,  18.13,  17.81  
49.93,  -4.88, -21.93  
43.14, -13.10,  21.91  
55.11,   8.84, -25.40  
70.72, -33.40, -0.20
62.66, 36.07, 57.1
40.02,  10.41 -45.96
51.12, 48.24 16.25
30.33 22.98 -21.59
72.53 -23.71 57.26
71.94 19.36 67.86
28.78 14.18 -50.3
55.26 -38.34 31.37
42.1 53.38 28.19
81.73 4.04 79.82
51.94 49.99 -14.57
51.04 -28.63 -28.64
96.54 -0.43 1.19
81.26 -0.64 -0.34
66.77 -0.73 -0.5
50.87 -0.15 -0.27
35.66 -0.42 -1.23
20.46 -0.08 -0.97
];

out.chipNames = chipNames;
out.sRGB_Values = sRGB_Values;
out.gray_Values = gray_Values;
out.Lab_CIE_D50 = Lab_CIE_D50;
out.RGB_Adobe = RGB_Adobe;

end