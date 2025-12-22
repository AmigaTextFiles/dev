#include <twiclasses/twimui/button.h>
#include <twiclasses/twimui/window.h>

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
