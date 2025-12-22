#include <citra/CITGroup.h>
#include <citra/CITButton.h>
#include <citra/CITClickTabPage.h>
#include <citra/CITString.h>
#include <citra/CITListBrowser.h>

CITApp Application;

CITWorkbench    myScreen;
CITWindow       myWindow;
CITVGroup       winGroup;
CITVGroup       pageGroup[2];
CITHGroup       nameGroup,cityGroup,phoneGroup;
CITHGroup       browserGroup,buttonGroup;
CITVGroup       ordersDetailGroup;
CITClickTabPage clickTab;
CITString       company,last,first;
CITString       address1,address2;
CITString       city,state,zip;
CITString       phone,fax;
CITListBrowser  customers,orders,details;
CITButton       newOrder,editOrder,deleteOrder;
CITButton       quitButton;

void CloseEvent();
void QuitEvent(ULONG ID,ULONG eventType);

int main()
{
  BOOL Error=FALSE;

  myScreen.InsObject(myWindow,Error);
    myWindow.Position(WPOS_CENTERSCREEN);
    myWindow.Activate();
    myWindow.CloseGadget();
    myWindow.DragBar();
    myWindow.SizeGadget();
    myWindow.DepthGadget();
    myWindow.IconifyGadget();
    myWindow.Caption("CITClickTab demo");
    myWindow.CloseEventHandler(CloseEvent);
    myWindow.InsObject(winGroup,Error);
      winGroup.InsObject(clickTab,Error);
      winGroup.SpaceOuter();
      winGroup.SpaceInner();
        clickTab.NewTab(pageGroup[0],"_Contacts");
          pageGroup[0].SpaceOuter();
          pageGroup[0].SpaceInner();
          pageGroup[0].BevelStyle(BVS_NONE);
          pageGroup[0].InsObject(company,Error);
            company.LabelText("Company:");
            company.TextVal("");
            company.MaxChars(48);
            company.TabCycle();
            company.MinWidth(200);
          pageGroup[0].InsObject(nameGroup,Error);
            nameGroup.WeightedHeight(0);
            nameGroup.InsObject(last,Error);
              last.LabelText("Last");
              last.TextVal("");
              last.MaxChars(48);
              last.TabCycle();
            nameGroup.InsObject(first,Error);
              first.LabelText("First");
              first.TextVal("");
              first.MaxChars(48);
              first.TabCycle();
          pageGroup[0].InsObject(address1,Error);
            address1.LabelText("Address 1");
            address1.TextVal("");
            address1.MaxChars(48);
            address1.TabCycle();
          pageGroup[0].InsObject(address2,Error);
            address2.LabelText("Address 1");
            address2.TextVal("");
            address2.MaxChars(48);
            address2.TabCycle();
          pageGroup[0].InsObject(cityGroup,Error);
            cityGroup.WeightedHeight(0);
            cityGroup.InsObject(city,Error);
              city.LabelText("City");
              city.TextVal("");
              city.MaxChars(48);
              city.TabCycle();
            cityGroup.InsObject(state,Error);
              state.LabelText("State");
              state.TextVal("");
              state.MaxChars(48);
              state.TabCycle();
            cityGroup.InsObject(zip,Error);
              zip.LabelText("ZipCode");
              zip.TextVal("");
              zip.MaxChars(24);
              zip.TabCycle();
          pageGroup[0].InsObject(phoneGroup,Error);
            phoneGroup.WeightedHeight(0);
            phoneGroup.BevelStyle(BVS_SBAR_VERT);
            phoneGroup.TopSpacing(2);
            phoneGroup.InsObject(phone,Error);
              phone.LabelText("phone");
              phone.TextVal("");
              phone.MaxChars(48);
              phone.TabCycle();
            nameGroup.InsObject(fax,Error);
              fax.LabelText("Fax");
              fax.TextVal("");
              fax.MaxChars(48);
              fax.TabCycle();
        clickTab.NewTab(pageGroup[1],"_Orders");
          pageGroup[1].SpaceOuter();
          pageGroup[1].SpaceInner();
          pageGroup[1].BevelStyle(BVS_NONE);
          pageGroup[1].InsObject(browserGroup,Error);
            browserGroup.SpaceInner();
            browserGroup.InsObject(customers,Error);
              customers.ShowSelected();
              customers.HorizontalProp();
              customers.WeightedWidth(30);
            browserGroup.InsObject(ordersDetailGroup,Error);
              ordersDetailGroup.SpaceInner();
              ordersDetailGroup.WeightedWidth(70);
              ordersDetailGroup.InsObject(orders,Error);
                orders.ShowSelected();
                orders.HorizontalProp();
              ordersDetailGroup.InsObject(details,Error);
                details.ShowSelected();
                details.HorizontalProp();
          pageGroup[1].InsObject(buttonGroup,Error);
            buttonGroup.WeightedHeight(0);
            buttonGroup.InsObject(newOrder,Error);
              newOrder.Text("_New Order");
            buttonGroup.InsObject(editOrder,Error);
              editOrder.Text("_Edit Order");
            buttonGroup.InsObject(deleteOrder,Error);
              deleteOrder.Text("_Delete Order");
      winGroup.InsObject(quitButton,Error);
        quitButton.Text("Quit");
        quitButton.WeightedHeight(0);
        quitButton.EventHandler(QuitEvent);

  //
  // Allign labels
  //
  myWindow.Align(pageGroup[0],nameGroup);
  myWindow.Align(nameGroup,cityGroup);
  myWindow.Align(cityGroup,phoneGroup);

  Application.InsObject(myScreen,Error);

  // Ok?
  if( Error )
    return 10;

  Application.Run();

  Application.RemObject(myScreen);

  return 0;
}

void QuitEvent(ULONG ID,ULONG eventType)
{
  Application.Stop();
}

void CloseEvent()
{
  Application.Stop();
}
