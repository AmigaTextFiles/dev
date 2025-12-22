#include <classes/twimui/button.h>
#include <classes/twimui/window.h>

class TWiWin : public MUIWindow
    {
    private:
        MUILabButton BSave;
        MUILabButton BUse;
        MUILabButton BCan;
    public:
        TWiWin();
        ~TWiWin() { };
    };
