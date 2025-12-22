/*	Public domain	*/

/* Begin generated block */
__BEGIN_DECLS
extern DECLSPEC M_Rectangle2 M_RectangleRead2(AG_DataSource *);
extern DECLSPEC M_Rectangle3 M_RectangleRead3(AG_DataSource *);
extern DECLSPEC void M_RectangleWrite2(AG_DataSource *, M_Rectangle2 *);
extern DECLSPEC void M_RectangleWrite3(AG_DataSource *, M_Rectangle3 *);
extern DECLSPEC M_Rectangle3 M_RectangleFromPts3(M_Vector3, M_Vector3, M_Vector3);
extern DECLSPEC M_Rectangle2 M_RectangleFromPts2(M_Vector2, M_Vector2);
#define M_RectangleFromLines(a,b,c) M_RectangleFromPts3((a).p,(b).p,(c).p)
#define M_RectangleFromLines2(a,b) M_RectangleFromPts3((a).p,(b).p)
__END_DECLS
/* Close generated block */
