VERSION 5.00
Begin VB.Form frmFonts 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Lichtkrant Font Maker"
   ClientHeight    =   5670
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6750
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   5670
   ScaleWidth      =   6750
   StartUpPosition =   1  'CenterOwner
   Begin VB.CheckBox chkKlein 
      Caption         =   "Klein Voorbeeld Activeren"
      Height          =   255
      Left            =   2640
      TabIndex        =   53
      Top             =   960
      Width           =   2655
   End
   Begin VB.CommandButton cmdDelLast 
      Caption         =   "Verwijder Laatste"
      Height          =   255
      Left            =   3240
      TabIndex        =   52
      Top             =   120
      Width           =   1455
   End
   Begin VB.CheckBox chkAutoExport 
      Caption         =   "Automatisch Exporteren"
      Height          =   255
      Left            =   2640
      TabIndex        =   51
      Top             =   1200
      Width           =   2535
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   39
      Left            =   1080
      Style           =   1  'Graphical
      TabIndex        =   50
      Top             =   1680
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   38
      Left            =   1080
      Style           =   1  'Graphical
      TabIndex        =   49
      Top             =   1440
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   37
      Left            =   1080
      Style           =   1  'Graphical
      TabIndex        =   48
      Top             =   1200
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   36
      Left            =   1080
      Style           =   1  'Graphical
      TabIndex        =   47
      Top             =   960
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   35
      Left            =   1080
      Style           =   1  'Graphical
      TabIndex        =   46
      Top             =   720
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   34
      Left            =   1080
      Style           =   1  'Graphical
      TabIndex        =   45
      Top             =   480
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   33
      Left            =   1080
      Style           =   1  'Graphical
      TabIndex        =   44
      Top             =   240
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   32
      Left            =   1080
      Style           =   1  'Graphical
      TabIndex        =   43
      Top             =   0
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   31
      Left            =   840
      Style           =   1  'Graphical
      TabIndex        =   42
      Top             =   1680
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   30
      Left            =   840
      Style           =   1  'Graphical
      TabIndex        =   41
      Top             =   1440
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   29
      Left            =   840
      Style           =   1  'Graphical
      TabIndex        =   40
      Top             =   1200
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   28
      Left            =   840
      Style           =   1  'Graphical
      TabIndex        =   39
      Top             =   960
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   27
      Left            =   840
      Style           =   1  'Graphical
      TabIndex        =   38
      Top             =   720
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   26
      Left            =   840
      Style           =   1  'Graphical
      TabIndex        =   37
      Top             =   480
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   25
      Left            =   840
      Style           =   1  'Graphical
      TabIndex        =   36
      Top             =   240
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   24
      Left            =   840
      Style           =   1  'Graphical
      TabIndex        =   35
      Top             =   0
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   23
      Left            =   600
      Style           =   1  'Graphical
      TabIndex        =   34
      Top             =   1680
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   22
      Left            =   600
      Style           =   1  'Graphical
      TabIndex        =   33
      Top             =   1440
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   21
      Left            =   600
      Style           =   1  'Graphical
      TabIndex        =   32
      Top             =   1200
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   20
      Left            =   600
      Style           =   1  'Graphical
      TabIndex        =   31
      Top             =   960
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   19
      Left            =   600
      Style           =   1  'Graphical
      TabIndex        =   30
      Top             =   720
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   18
      Left            =   600
      Style           =   1  'Graphical
      TabIndex        =   29
      Top             =   480
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   17
      Left            =   600
      Style           =   1  'Graphical
      TabIndex        =   28
      Top             =   240
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   16
      Left            =   600
      Style           =   1  'Graphical
      TabIndex        =   27
      Top             =   0
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   15
      Left            =   360
      Style           =   1  'Graphical
      TabIndex        =   26
      Top             =   1680
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   14
      Left            =   360
      Style           =   1  'Graphical
      TabIndex        =   25
      Top             =   1440
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   13
      Left            =   360
      Style           =   1  'Graphical
      TabIndex        =   24
      Top             =   1200
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   12
      Left            =   360
      Style           =   1  'Graphical
      TabIndex        =   23
      Top             =   960
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   11
      Left            =   360
      Style           =   1  'Graphical
      TabIndex        =   22
      Top             =   720
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   10
      Left            =   360
      Style           =   1  'Graphical
      TabIndex        =   21
      Top             =   480
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   9
      Left            =   360
      Style           =   1  'Graphical
      TabIndex        =   20
      Top             =   240
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   8
      Left            =   360
      Style           =   1  'Graphical
      TabIndex        =   19
      Top             =   0
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   7
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   18
      Top             =   1680
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   6
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   17
      Top             =   1440
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   5
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   16
      Top             =   1200
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   4
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   15
      Top             =   960
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   3
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   14
      Top             =   720
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   2
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   13
      Top             =   480
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   1
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   12
      Top             =   240
      Width           =   255
   End
   Begin VB.CommandButton Blokjes 
      Appearance      =   0  'Flat
      BackColor       =   &H00FFFFFF&
      Height          =   255
      Index           =   0
      Left            =   120
      Style           =   1  'Graphical
      TabIndex        =   11
      TabStop         =   0   'False
      Top             =   0
      Width           =   255
   End
   Begin VB.CommandButton cmdExport 
      Caption         =   "Exporteren"
      Height          =   375
      Left            =   3960
      TabIndex        =   9
      Top             =   1560
      Width           =   1215
   End
   Begin VB.CommandButton cmdImport 
      Caption         =   "Importeren"
      Height          =   375
      Left            =   2640
      TabIndex        =   8
      Top             =   1560
      Width           =   1215
   End
   Begin VB.CommandButton cmdNext 
      Caption         =   ">"
      Height          =   255
      Left            =   2880
      TabIndex        =   7
      Top             =   120
      Width           =   255
   End
   Begin VB.CommandButton cmdPrevious 
      Caption         =   "<"
      Height          =   255
      Left            =   2640
      TabIndex        =   6
      Top             =   120
      Width           =   255
   End
   Begin VB.TextBox txtBox 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   3615
      Left            =   0
      MultiLine       =   -1  'True
      ScrollBars      =   2  'Vertical
      TabIndex        =   5
      Top             =   2040
      Width           =   6735
   End
   Begin VB.TextBox Hex5 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1560
      TabIndex        =   4
      Text            =   "0x00"
      Top             =   1560
      Width           =   855
   End
   Begin VB.TextBox Hex4 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1560
      TabIndex        =   3
      Text            =   "0x00"
      Top             =   1200
      Width           =   855
   End
   Begin VB.TextBox Hex3 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1560
      TabIndex        =   2
      Text            =   "0x00"
      Top             =   840
      Width           =   855
   End
   Begin VB.TextBox Hex2 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1560
      TabIndex        =   1
      Text            =   "0x00"
      Top             =   480
      Width           =   855
   End
   Begin VB.TextBox Hex1 
      BeginProperty Font 
         Name            =   "Courier New"
         Size            =   9.75
         Charset         =   0
         Weight          =   400
         Underline       =   0   'False
         Italic          =   0   'False
         Strikethrough   =   0   'False
      EndProperty
      Height          =   285
      Left            =   1560
      TabIndex        =   0
      Text            =   "0x00"
      Top             =   120
      Width           =   855
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   39
      Left            =   6120
      Shape           =   1  'Square
      Top             =   1320
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   38
      Left            =   6120
      Shape           =   1  'Square
      Top             =   1200
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   37
      Left            =   6120
      Shape           =   1  'Square
      Top             =   1080
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   36
      Left            =   6120
      Shape           =   1  'Square
      Top             =   960
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   35
      Left            =   6120
      Shape           =   1  'Square
      Top             =   840
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   34
      Left            =   6120
      Shape           =   1  'Square
      Top             =   720
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   33
      Left            =   6120
      Shape           =   1  'Square
      Top             =   600
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   32
      Left            =   6120
      Shape           =   1  'Square
      Top             =   480
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   31
      Left            =   6000
      Shape           =   1  'Square
      Top             =   1320
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   30
      Left            =   6000
      Shape           =   1  'Square
      Top             =   1200
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   29
      Left            =   6000
      Shape           =   1  'Square
      Top             =   1080
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   28
      Left            =   6000
      Shape           =   1  'Square
      Top             =   960
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   27
      Left            =   6000
      Shape           =   1  'Square
      Top             =   840
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   26
      Left            =   6000
      Shape           =   1  'Square
      Top             =   720
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   25
      Left            =   6000
      Shape           =   1  'Square
      Top             =   600
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   24
      Left            =   6000
      Shape           =   1  'Square
      Top             =   480
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   23
      Left            =   5880
      Shape           =   1  'Square
      Top             =   1320
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   22
      Left            =   5880
      Shape           =   1  'Square
      Top             =   1200
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   21
      Left            =   5880
      Shape           =   1  'Square
      Top             =   1080
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   20
      Left            =   5880
      Shape           =   1  'Square
      Top             =   960
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   19
      Left            =   5880
      Shape           =   1  'Square
      Top             =   840
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   18
      Left            =   5880
      Shape           =   1  'Square
      Top             =   720
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   17
      Left            =   5880
      Shape           =   1  'Square
      Top             =   600
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   16
      Left            =   5880
      Shape           =   1  'Square
      Top             =   480
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   15
      Left            =   5760
      Shape           =   1  'Square
      Top             =   1320
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   14
      Left            =   5760
      Shape           =   1  'Square
      Top             =   1200
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   13
      Left            =   5760
      Shape           =   1  'Square
      Top             =   1080
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   12
      Left            =   5760
      Shape           =   1  'Square
      Top             =   960
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   11
      Left            =   5760
      Shape           =   1  'Square
      Top             =   840
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   10
      Left            =   5760
      Shape           =   1  'Square
      Top             =   720
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   9
      Left            =   5760
      Shape           =   1  'Square
      Top             =   600
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   8
      Left            =   5760
      Shape           =   1  'Square
      Top             =   480
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   7
      Left            =   5640
      Shape           =   1  'Square
      Top             =   1320
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   6
      Left            =   5640
      Shape           =   1  'Square
      Top             =   1200
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   5
      Left            =   5640
      Shape           =   1  'Square
      Top             =   1080
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   4
      Left            =   5640
      Shape           =   1  'Square
      Top             =   960
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   3
      Left            =   5640
      Shape           =   1  'Square
      Top             =   840
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   2
      Left            =   5640
      Shape           =   1  'Square
      Top             =   720
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   1
      Left            =   5640
      Shape           =   1  'Square
      Top             =   600
      Width           =   135
   End
   Begin VB.Shape KleineBlokjes 
      BackStyle       =   1  'Opaque
      BorderColor     =   &H00E0E0E0&
      FillColor       =   &H00FFFFFF&
      FillStyle       =   0  'Solid
      Height          =   135
      Index           =   0
      Left            =   5640
      Shape           =   1  'Square
      Top             =   480
      Width           =   135
   End
   Begin VB.Label lblHuidige 
      Caption         =   "1/1"
      Height          =   255
      Left            =   2640
      TabIndex        =   10
      Top             =   480
      Width           =   2535
   End
End
Attribute VB_Name = "frmFonts"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Dim Letters(3000) As String
Dim HuidigeLetter As Integer
Dim Totaal As Integer

Private Sub Blokjes_Click(Index As Integer)
    If Blokjes(Index).BackColor = &HFFFFFF Then
        Blokjes(Index).BackColor = &H0&
    Else
        Blokjes(Index).BackColor = &HFFFFFF
    End If
    PasKleineAan
    Hex1.Text = "0x" & MaakHexrij(0)
    Hex2.Text = "0x" & MaakHexrij(8)
    Hex3.Text = "0x" & MaakHexrij(16)
    Hex4.Text = "0x" & MaakHexrij(24)
    Hex5.Text = "0x" & MaakHexrij(32)
    Letters(HuidigeLetter * 5 - 5) = Hex1.Text
    Letters(HuidigeLetter * 5 - 4) = Hex2.Text
    Letters(HuidigeLetter * 5 - 3) = Hex3.Text
    Letters(HuidigeLetter * 5 - 2) = Hex4.Text
    Letters(HuidigeLetter * 5 - 1) = Hex5.Text
    txtBox.SetFocus
    If chkAutoExport.Value = 1 Then cmdExport_Click
    
End Sub

Private Sub chkKlein_Click()
    PasKleineAan
End Sub

Private Sub chkKlein_KeyPress(KeyAscii As Integer)
    PasKleineAan
End Sub

Private Sub cmdDelLast_Click()
    If Totaal > 1 Then
        Letters(Totaal * 5 - 5) = "0x00"
        Letters(Totaal * 5 - 4) = "0x00"
        Letters(Totaal * 5 - 3) = "0x00"
        Letters(Totaal * 5 - 2) = "0x00"
        Letters(Totaal * 5 - 1) = "0x00"
        Totaal = Totaal - 1
        If HuidigeLetter > Totaal Then HuidigeLetter = HuidigeLetter - 1
    End If
    lblHuidige.Caption = HuidigeLetter & "/" & Totaal
    RestoreLetter
End Sub

Private Sub cmdExport_Click()
    Dim i As Integer
    Dim j As Integer
    txtBox.Text = ""
    For i = 1 To Int((Totaal * 5) / 8) + 1
        txtBox.Text = txtBox.Text & "__EEPROM_DATA("
        For j = 1 To 8
            txtBox.Text = txtBox.Text & Letters((i * 8) + j - 9) & ","
        Next j
        txtBox.Text = Left(txtBox.Text, Len(txtBox.Text) - 1) & ");" & vbCrLf
    Next i
End Sub

Private Sub cmdImport_Click()
    If Right(txtBox.Text, 2) <> vbCrLf Then txtBox.Text = txtBox.Text & vbCrLf
    Dim i As Integer
    For i = 1 To Len(txtBox.Text) / 57
        Letters(i * 8 - 8) = Mid(txtBox.Text, i * 57 - 57 + 15, 4)
        Letters(i * 8 - 7) = Mid(txtBox.Text, i * 57 - 57 + 15 + 5 * 1, 4)
        Letters(i * 8 - 6) = Mid(txtBox.Text, i * 57 - 57 + 15 + 5 * 2, 4)
        Letters(i * 8 - 5) = Mid(txtBox.Text, i * 57 - 57 + 15 + 5 * 3, 4)
        Letters(i * 8 - 4) = Mid(txtBox.Text, i * 57 - 57 + 15 + 5 * 4, 4)
        Letters(i * 8 - 3) = Mid(txtBox.Text, i * 57 - 57 + 15 + 5 * 5, 4)
        Letters(i * 8 - 2) = Mid(txtBox.Text, i * 57 - 57 + 15 + 5 * 6, 4)
        Letters(i * 8 - 1) = Mid(txtBox.Text, i * 57 - 57 + 15 + 5 * 7, 4)
    Next i
    Totaal = Round(((i - 1) * 8) / 5)
    lblHuidige.Caption = HuidigeLetter & "/" & Totaal
    RestoreLetter
End Sub

Private Sub cmdNext_Click()
    If HuidigeLetter <= Totaal Then HuidigeLetter = HuidigeLetter + 1
    If HuidigeLetter > Totaal Then Totaal = HuidigeLetter
    lblHuidige.Caption = HuidigeLetter & "/" & Totaal
    RestoreLetter
End Sub

Private Sub cmdPrevious_Click()
    If HuidigeLetter > 1 Then HuidigeLetter = HuidigeLetter - 1
    lblHuidige.Caption = HuidigeLetter & "/" & Totaal
    RestoreLetter
End Sub

Sub RestoreLetter()
    Hex1.Text = Letters(HuidigeLetter * 5 - 5)
    Hex2.Text = Letters(HuidigeLetter * 5 - 4)
    Hex3.Text = Letters(HuidigeLetter * 5 - 3)
    Hex4.Text = Letters(HuidigeLetter * 5 - 2)
    Hex5.Text = Letters(HuidigeLetter * 5 - 1)
    NaarBlokjes 0, Hex1.Text
    NaarBlokjes 8, Hex2.Text
    NaarBlokjes 16, Hex3.Text
    NaarBlokjes 24, Hex4.Text
    NaarBlokjes 32, Hex5.Text
End Sub

Function MaakHexrij(beginblokje As Integer) As String
    Dim tijdl As Integer
    tijdl = IIf(Blokjes(beginblokje + 7).BackColor = &H0&, 1, 0)
    tijdl = tijdl + IIf(Blokjes(beginblokje + 6).BackColor = &H0&, 2, 0)
    tijdl = tijdl + IIf(Blokjes(beginblokje + 5).BackColor = &H0&, 4, 0)
    tijdl = tijdl + IIf(Blokjes(beginblokje + 4).BackColor = &H0&, 8, 0)
    tijdl = tijdl + IIf(Blokjes(beginblokje + 3).BackColor = &H0&, 16, 0)
    tijdl = tijdl + IIf(Blokjes(beginblokje + 2).BackColor = &H0&, 32, 0)
    tijdl = tijdl + IIf(Blokjes(beginblokje + 1).BackColor = &H0&, 64, 0)
    tijdl = tijdl + IIf(Blokjes(beginblokje).BackColor = &H0&, 128, 0)
    MaakHexrij = Hex$(tijdl)
    If Len(MaakHexrij) = 1 Then MaakHexrij = "0" & MaakHexrij
End Function

Sub NaarBlokjes(beginblokje As Integer, textje As String)
    Dim tijdl As Integer
    tijdl = Int(Val(FromHex(Right(textje, 2))))
    If tijdl - 128 >= 0 Then tijdl = tijdl - 128: Blokjes(beginblokje).BackColor = &H0& Else Blokjes(beginblokje).BackColor = &HFFFFFF
    If tijdl - 64 >= 0 Then tijdl = tijdl - 64: Blokjes(beginblokje + 1).BackColor = &H0& Else Blokjes(beginblokje + 1).BackColor = &HFFFFFF
    If tijdl - 32 >= 0 Then tijdl = tijdl - 32: Blokjes(beginblokje + 2).BackColor = &H0& Else Blokjes(beginblokje + 2).BackColor = &HFFFFFF
    If tijdl - 16 >= 0 Then tijdl = tijdl - 16: Blokjes(beginblokje + 3).BackColor = &H0& Else Blokjes(beginblokje + 3).BackColor = &HFFFFFF
    If tijdl - 8 >= 0 Then tijdl = tijdl - 8: Blokjes(beginblokje + 4).BackColor = &H0& Else Blokjes(beginblokje + 4).BackColor = &HFFFFFF
    If tijdl - 4 >= 0 Then tijdl = tijdl - 4: Blokjes(beginblokje + 5).BackColor = &H0& Else Blokjes(beginblokje + 5).BackColor = &HFFFFFF
    If tijdl - 2 >= 0 Then tijdl = tijdl - 2: Blokjes(beginblokje + 6).BackColor = &H0& Else Blokjes(beginblokje + 6).BackColor = &HFFFFFF
    If tijdl - 1 >= 0 Then tijdl = tijdl - 1: Blokjes(beginblokje + 7).BackColor = &H0& Else Blokjes(beginblokje + 7).BackColor = &HFFFFFF
    Letters(HuidigeLetter * 5 - 5) = Hex1.Text
    Letters(HuidigeLetter * 5 - 4) = Hex2.Text
    Letters(HuidigeLetter * 5 - 3) = Hex3.Text
    Letters(HuidigeLetter * 5 - 2) = Hex4.Text
    Letters(HuidigeLetter * 5 - 1) = Hex5.Text
    If chkAutoExport.Value = 1 Then cmdExport_Click
    PasKleineAan
End Sub

Function FromHex(sIn As String) As Integer
Dim AscVal As Integer
Dim ch As String
Dim f As Integer
Dim i As Integer
Dim s As String
s = UCase$(sIn)
f = 0
For i = 1 To Len(s)
    ch = Mid$(s, i, 1)
    If InStr("0123456789ABCDEF", ch) = 0 Then FromHex = 0: Exit Function
    AscVal = Asc(ch) - 48
    If AscVal > 10 Then
        AscVal = AscVal - 7
    End If
    f = f * 16 + AscVal
Next i
FromHex = f
End Function

Sub PasKleineAan()
    Dim i As Integer
    For i = 0 To 39
        If chkKlein.Value = 1 Then
            KleineBlokjes(i).FillColor = Blokjes(i).BackColor
        Else
            KleineBlokjes(i).FillColor = &HFFFFFF
        End If
    Next i
End Sub

Private Sub Form_Load()
    Totaal = 1
    HuidigeLetter = 1
    Dim i As Integer
    For i = 0 To 3000
        Letters(i) = "0x00"
    Next i
    For i = 0 To 39
        Blokjes(i).TabStop = False
    Next i
End Sub

Private Sub Hex1_KeyUp(KeyCode As Integer, Shift As Integer)
    NaarBlokjes 0, Hex1.Text
End Sub

Private Sub Hex2_KeyUp(KeyCode As Integer, Shift As Integer)
    NaarBlokjes 8, Hex2.Text
End Sub

Private Sub Hex3_KeyUp(KeyCode As Integer, Shift As Integer)
    NaarBlokjes 16, Hex3.Text
End Sub

Private Sub Hex4_KeyUp(KeyCode As Integer, Shift As Integer)
    NaarBlokjes 24, Hex4.Text
End Sub

Private Sub Hex5_KeyUp(KeyCode As Integer, Shift As Integer)
    NaarBlokjes 32, Hex5.Text
End Sub

