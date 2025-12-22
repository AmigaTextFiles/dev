char* pioche_pgm(int);
char* pioche_MNA(int);
int norm_pente(float);
int norm_pluie(int);
int sens_pente(float);
int normalisation(int);
void loop(int);
BOOL IO_boucle();
void circle_param(int, int, int, int&, int&, float);

char* pioche_pgm(int k)
{
    char *preserve[151]={"p00.pgm",
                        "p01.pgm", "p02.pgm", "p03.pgm", "p04.pgm", "p05.pgm",
                        "p06.pgm", "p07.pgm", "p08.pgm", "p09.pgm", "p10.pgm",
                        "p11.pgm", "p12.pgm", "p13.pgm", "p14.pgm", "p15.pgm",
                        "p16.pgm", "p17.pgm", "p18.pgm", "p19.pgm", "p20.pgm",
                        "p21.pgm", "p22.pgm", "p23.pgm", "p24.pgm", "p25.pgm",
                        "p26.pgm", "p27.pgm", "p28.pgm", "p29.pgm", "p30.pgm",
                        "p31.pgm", "p32.pgm", "p33.pgm", "p34.pgm", "p35.pgm",
                        "p36.pgm", "p37.pgm", "p38.pgm", "p39.pgm", "p40.pgm",
                        "p41.pgm", "p42.pgm", "p43.pgm", "p44.pgm", "p45.pgm",
                        "p46.pgm", "p47.pgm", "p48.pgm", "p49.pgm", "p50.pgm",
                        "p51.pgm", "p52.pgm", "p53.pgm", "p54.pgm", "p55.pgm",
                        "p56.pgm", "p57.pgm", "p58.pgm", "p59.pgm", "p60.pgm",
                        "p61.pgm", "p62.pgm", "p63.pgm", "p64.pgm", "p65.pgm",
                        "p66.pgm", "p67.pgm", "p68.pgm", "p69.pgm", "p70.pgm",
                        "p71.pgm", "p72.pgm", "p73.pgm", "p74.pgm", "p75.pgm",
                        "p76.pgm", "p77.pgm", "p78.pgm", "p79.pgm", "p80.pgm",
                        "p81.pgm", "p82.pgm", "p83.pgm", "p84.pgm", "p85.pgm",
                        "p86.pgm", "p87.pgm", "p88.pgm", "p89.pgm", "p90.pgm",
                        "p91.pgm", "p92.pgm", "p93.pgm", "p94.pgm", "p95.pgm",
                        "p96.pgm", "p97.pgm", "p98.pgm", "p99.pgm", "p100.pgm",
                        "p101.pgm", "p102.pgm", "p103.pgm", "p104.pgm", "p105.pgm",
                        "p106.pgm", "p107.pgm", "p108.pgm", "p109.pgm", "p110.pgm",
                        "p111.pgm", "p112.pgm", "p113.pgm", "p114.pgm", "p115.pgm",
                        "p116.pgm", "p117.pgm", "p118.pgm", "p119.pgm", "p120.pgm",
                        "p121.pgm", "p122.pgm", "p123.pgm", "p124.pgm", "p125.pgm",
                        "p126.pgm", "p127.pgm", "p128.pgm", "p129.pgm", "p130.pgm",
                        "p131.pgm", "p132.pgm", "p133.pgm", "p134.pgm", "p135.pgm",
                        "p136.pgm", "p137.pgm", "p138.pgm", "p139.pgm", "p140.pgm",
                        "p141.pgm", "p142.pgm", "p143.pgm", "p144.pgm", "p145.pgm",
                        "p146.pgm", "p147.pgm", "p148.pgm", "p149.pgm", "p150.pgm"};
    return preserve[k];
}

char* pioche_MNA(int k)
{
    char *preserve[101]={"M00.pgm",
                        "M01.pgm", "M02.pgm", "M03.pgm", "M04.pgm", "M05.pgm",
                        "M06.pgm", "M07.pgm", "M08.pgm", "M09.pgm", "M10.pgm",
                        "M11.pgm", "M12.pgm", "M13.pgm", "M14.pgm", "M15.pgm",
                        "M16.pgm", "M17.pgm", "M18.pgm", "M19.pgm", "M20.pgm",
                        "M21.pgm", "M22.pgm", "M23.pgm", "M24.pgm", "M25.pgm",
                        "M26.pgm", "M27.pgm", "M28.pgm", "M29.pgm", "M30.pgm",
                        "M31.pgm", "M32.pgm", "M33.pgm", "M34.pgm", "M35.pgm",
                        "M36.pgm", "M37.pgm", "M38.pgm", "M39.pgm", "M40.pgm",
                        "M41.pgm", "M42.pgm", "M43.pgm", "M44.pgm", "M45.pgm",
                        "M46.pgm", "M47.pgm", "M48.pgm", "M49.pgm", "M50.pgm",
                        "M51.pgm", "M52.pgm", "M53.pgm", "M54.pgm", "M55.pgm",
                        "M56.pgm", "M57.pgm", "M58.pgm", "M59.pgm", "M60.pgm",
                        "M61.pgm", "M62.pgm", "M63.pgm", "M64.pgm", "M65.pgm",
                        "M66.pgm", "M67.pgm", "M68.pgm", "M69.pgm", "M70.pgm",
                        "M71.pgm", "M72.pgm", "M73.pgm", "M74.pgm", "M75.pgm",
                        "M76.pgm", "M77.pgm", "M78.pgm", "M79.pgm", "M80.pgm",
                        "M81.pgm", "M82.pgm", "M83.pgm", "M84.pgm", "M85.pgm",
                        "M86.pgm", "M87.pgm", "M88.pgm", "M89.pgm", "M90.pgm",
                        "M91.pgm", "M92.pgm", "M93.pgm", "M94.pgm", "M95.pgm",
                        "M96.pgm", "M97.pgm", "M98.pgm", "M99.pgm", "M100.pgm"};
    return preserve[k];
}

int norm_pluie(int pluie)      //normaliser la pluviométrie
{
    int pluie_int=0;
    if(pluie<300)
        pluie_int=(-1);
    if((pluie>=300) && (pluie<=600))
        pluie_int=0;
    if(pluie>600)
        pluie_int=1;
    return pluie_int;
}

int norm_pente(float pente)             //normaliser la pente
{
    int pente_int=0;
    if(pente<0.29)
        pente_int=1;
    if((pente>=0.29) && (pente<=0.89))
        pente_int=0;
    if(pente>0.89)
        pente_int=(-1);
    return pente_int;
}

int sens_pente(float pente)
{
    int sens=0;
    if(pente>0)
        sens=1;
    else
        sens=-1;
    return sens;
}

int normalisation(int somme1)      //bloquer l'augmentation
{
    int somme2=0;
    if(somme1>=1)
        somme2=2;
    else
        somme2=somme1;
    if(somme2<=-1)
        somme2=-2;
    return somme2;
}

void loop(int loop_tick)
{
    printf(" tick: %d", loop_tick);
    loop_tick++;
}

BOOL IO_boucle()
{
    BOOL pause=FALSE, fermer=FALSE;
    Emperor_Input=0L;
    do
    {
        while((Emperor_Input = RA_HandleInput(WindowObject1, &Emperor_Code)) != WMHI_LASTMSG)
        {
            //printf("input reçu: %d\n", Emperor_Input);
            switch(Emperor_Input & WMHI_CLASSMASK)
            {
                case WMHI_GADGETUP:
                    switch(Emperor_Input & WMHI_GADGETMASK)
                    {
                        case 39:
                            //Button3_GadgetUp_Event();
                            //printf("case pause: %d\n", pause);
                            if(pause==TRUE)
                            {
                                pause=FALSE;
                                SetGadgetAttrs(Button6, Window1, NULL, GA_Disabled, TRUE, TAG_DONE);
                            }
                            else
                            {
                                pause=TRUE;
                                SetGadgetAttrs(Button6, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
                            }
                            //printf("case pause: %d\n", pause);
                            break;
                        case 42:
                            //Button6_GadgetUp_Event();
                            //printf("case fermer: %d\n");
                            SetGadgetAttrs(Button3, Window1, NULL, GA_Selected, FALSE, TAG_DONE);
                            SetGadgetAttrs(Button6, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
                            SetGadgetAttrs(Button7, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
                            SetGadgetAttrs(Button8, Window1, NULL, GA_Disabled, FALSE, TAG_DONE);
                            fermer=TRUE;
                            return fermer;
                            break;
                        case 46:
                            Button7_GadgetUp_Event();
                            break;
                        case 47:
                            Button8_GadgetUp_Event();
                            break;
                        default:
                            pause=FALSE;
                            break;
                    }
                default:
                    break;
            }
        }
    }
    while(pause==TRUE);
}

void circle_param(int tempr, int i, int j, int& x, int& y, float alpha)
{
    float tempx=0.0, tempy=0.0, arrx=0.0, arry=0.0;
    tempx = tempr * cos(alpha);
    arrx = floor(tempx);
    if((tempx-arrx)<0.5)
    {
        tempx=floor(tempx);
    }
    else
    {
        tempx=ceil(tempx);
    }
    tempy = tempr * sin(alpha);
    arry = floor(tempy);
    if((tempy-arry)<0.5)
    {
        tempy=floor(tempy);
    }
    else
    {
        tempy=ceil(tempy);
    }
    x = i + int(tempx);
    y = j + int(tempy);
}
