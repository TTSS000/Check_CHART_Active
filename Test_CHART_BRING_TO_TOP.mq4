//+------------------------------------------------------------------+
//|                                      Test_CHART_BRING_TO_TOP.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
#import "user32.dll"
//int  RegisterWindowMessageW(string MessageName); // For Start custom indicator
//int  PostMessageW(int hwnd,int msg,int wparam,uchar &Name[]); // For Start custom indicator
//int  FindWindowW(string lpszClass,string lpszWindow); // For Start custom indicator
// int  keybd_event(int bVk, int bScan, int dwFlags, int dwExtraInfo); // For Start custom indicator
int IsIconic(int hWnd);
int GetParent(int hWnd);
int GetAncestor(int,int);
int GetForegroundWindow(void);
//int PostMessageA(int hWnd,int Msg,int wParam,int lParam);
//uint SendInput(uint cInputs, LPINPUT pInputs, int cbSize);
//#import "kernel32.dll"
//void Sleep(int dwMilliseconds);
#import

bool g_b_CHART_BRING_TO_TOP=false;
bool g_b_CHART_ICONIC=false;
bool g_b_MT4_ICONIC=false;
bool g_b_MT4_Foreground=false;
int g_hWnd_Foreground=0;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
//--- indicator buffers mapping

//---
  return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
//---
  int hWnd_Chart = ChartGetInteger(0,CHART_WINDOW_HANDLE);
  int hWnd_Chart_Window = GetParent(hWnd_Chart);
  int hWnd_MT4 = GetAncestor(hWnd_Chart, 2);
  //CHART_BRING_TO_TOP
  if(g_b_CHART_BRING_TO_TOP != ChartGetInteger(0,CHART_BRING_TO_TOP)) {
    // Do Something...
    // chart is not active
    //return;
    g_b_CHART_BRING_TO_TOP = ChartGetInteger(0,CHART_BRING_TO_TOP);
    Print("g_b_CHART_BRING_TO_TOP="+g_b_CHART_BRING_TO_TOP);
  }
    //Print("g_b_CHART_ICONIC 0="+g_b_CHART_ICONIC);


  //if(g_b_CHART_ICONIC != IsIconic(GetParent(ChartGetInteger(0,CHART_WINDOW_HANDLE)))) {
  //  g_b_CHART_ICONIC = IsIconic(GetParent(ChartGetInteger(0,CHART_WINDOW_HANDLE)));
  //  Print("g_b_CHART_ICONIC 1="+g_b_CHART_ICONIC);
  //}
  if(g_b_CHART_ICONIC != IsIconic(hWnd_Chart_Window)){
    g_b_CHART_ICONIC = IsIconic(hWnd_Chart_Window);
    Print("g_b_CHART_ICONIC 1="+g_b_CHART_ICONIC);
  }

  if(g_b_MT4_ICONIC != IsIconic(GetAncestor(ChartGetInteger(0,CHART_WINDOW_HANDLE),2))) {
    g_b_MT4_ICONIC = IsIconic(GetAncestor(ChartGetInteger(0,CHART_WINDOW_HANDLE),2));
    Print("g_b_MT4_ICONIC 1="+g_b_MT4_ICONIC);
  }
  g_hWnd_Foreground = user32::GetForegroundWindow();
  if(g_hWnd_Foreground == hWnd_MT4 && !g_b_MT4_Foreground){
    g_b_MT4_Foreground = true;
    Print("g_b_MT4_Foreground 1="+g_b_MT4_Foreground);
  }else if(g_hWnd_Foreground != hWnd_MT4 && g_b_MT4_Foreground){
    g_b_MT4_Foreground = false;
    Print("g_b_MT4_Foreground 1="+g_b_MT4_Foreground);
  }
//--- return value of prev_calculated for next call
  return(rates_total);
}
//+------------------------------------------------------------------+
