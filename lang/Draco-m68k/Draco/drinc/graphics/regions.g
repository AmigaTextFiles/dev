type
„Rectangle_t=unknown8,

„RegionRectangle_t=struct{
ˆ*RegionRectangle_trr_Next,rr_Prev;
ˆRectangle_trr_bounds;
„},

„Region_t=struct{
ˆRectangle_trg_bounds;
ˆ*RegionRectangle_trg_RegionRectangle;
„};

extern
„AndRectRegion(*Region_trg;*Rectangle_tr)void,
„AndRegionRegion(*Region_trg1,rg2)bool,
„ClearRectRegion(*Region_trg;*Rectangle_tr)bool,
„ClearRegion(*Region_trg)void,
„DisposeRegion(*Region_trg)void,
„NewRegion()*Region_t,
„OrRectRegion(*Region_trg;*Rectangle_tr)bool,
„OrRegionRegion(*Region_trg1,rg2)bool,
„XorRectRegion(*Region_trg;*Rectangle_tr)bool,
„XorRegionRegion(*Region_trg1,rg2)bool;
