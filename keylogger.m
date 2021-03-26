#import <Carbon/Carbon.h>
#import <Foundation/Foundation.h>
#import <ApplicationServices/ApplicationServices.h>

#import "KeyCodeFormatter.h"

//event tap
static CFMachPortRef eventTap = NULL;

//build string of key modifiers (shift, command, etc)
// ->code based on: https://stackoverflow.com/a/4425180/3854841
NSMutableString* extractKeyModifiers(CGEventRef event)
{
    //key modify(ers)
    NSMutableString* keyModifiers = nil;
    
    //flags
    CGEventFlags flags = 0;
    
    //alloc
    keyModifiers = [NSMutableString string];
    
    //get flags
    flags = CGEventGetFlags(event);
    
    //control
    if(YES == !!(flags & kCGEventFlagMaskControl))
    {
        [keyModifiers appendString:@"control "];
    }
    
    //alt or option key
    if(YES == !!(flags & kCGEventFlagMaskAlternate))
    {
        [keyModifiers appendString:@"alt "];
    }
    
    //command
    if(YES == !!(flags & kCGEventFlagMaskCommand))
    {
        [keyModifiers appendString:@"command "];
    }
    
    //shift
    if(YES == !!(flags & kCGEventFlagMaskShift))
    {
        [keyModifiers appendString:@"shift "];
    }
    
    //caps lock
    if(YES == !!(flags & kCGEventFlagMaskAlphaShift))
    {
        [keyModifiers appendString:@"caps lock "];
    }

    return keyModifiers;
}

//callback for mouse/keyboard events
CGEventRef eventCallback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon)
{
    //(key) code
    CGKeyCode keyCode = 0;

    // key code as string
    NSString *keyCodeString = @"";
    
    //key modify(ers)
    NSMutableString* keyModifiers = nil;

    switch(type)
    {
        //key up
        case kCGEventKeyUp:
            keyModifiers = extractKeyModifiers(event);
            break;
        
        // event tap timeout
        case kCGEventTapDisabledByTimeout:
            CGEventTapEnable(eventTap, true);
            return event;
        
        // other events such as KeyDown
        default:
            return event;
    }
    
    keyCode = (CGKeyCode)CGEventGetIntegerValueField(event, kCGKeyboardEventKeycode);
    keyCodeString = stringFromKeyCode(keyCode);

    // for csv output we need to escape the delimiter
    if ([keyCodeString isEqualToString:@","]) {
        keyCodeString = @"\",\"";
    }

    printf("%s,%s\n", keyCodeString.UTF8String, keyModifiers.UTF8String);
    
    return event;
}

//main interface
// ->parse args, then sniff (forever)
int main(int argc, const char * argv[])
{
    // disable buffering on stdout
    setbuf(stdout, NULL);

    //event mask
    // ->events to sniff
    CGEventMask eventMask = 0;
    
    //run loop source
    CFRunLoopSourceRef runLoopSource = NULL;


    //pool
    @autoreleasepool
    {
        // unless this program has been added to 'Security & Privacy' -> 'Accessibility'
        if(0 != geteuid())
        {
            //err msg/bail
            printf("ERROR: run as root\n\n");
            goto bail;
        }
        
        // ->just sniff keyboard
        eventMask = CGEventMaskBit(kCGEventKeyDown) | CGEventMaskBit(kCGEventKeyUp);
            
        //create event tap
        eventTap = CGEventTapCreate(kCGSessionEventTap, kCGHeadInsertEventTap, 0, eventMask, eventCallback, NULL);
        if(NULL == eventTap)
        {
            //err msg/bail
            printf("ERROR: failed to create event tap\n");
            goto bail;
        }
        
        //run loop source
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);
        
        //add to current run loop.
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, kCFRunLoopCommonModes);
        
        //enable tap
        CGEventTapEnable(eventTap, true);
        
        //go, go, go
        CFRunLoopRun();
    }
    
bail:
    
    //release event tap
    if(NULL != eventTap)
    {
        //release
        CFRelease(eventTap);
        
        //unset
        eventTap = NULL;
    }
    
    //release run loop src
    if(NULL != runLoopSource)
    {
        //release
        CFRelease(runLoopSource);
        
        //unset
        runLoopSource = NULL;
    }
    
    return 0;
}

#define nsni(val) [NSNumber numberWithUnsignedInteger: val]

NSDictionary<NSNumber*, NSString*>* nonPritableKeys;

void initialize() {
    nonPritableKeys = @{
        nsni(kVK_Return): @"ENTER",
        nsni(kVK_Tab): @"TAB",
        nsni(kVK_Space): @"SPACE",
        nsni(kVK_Escape): @"ESC",
        nsni(kVK_Shift): @"SHIFT",
        nsni(kVK_RightShift): @"R SHIFT",
        nsni(kVK_Option): @"OPTION",
        nsni(kVK_RightOption): @"R OPTION",
        nsni(kVK_Command): @"COMMAND",
        nsni(kVK_RightCommand): @"R COMMAND",
        nsni(kVK_Control): @"CONTROL",
        nsni(kVK_RightControl): @"R CONTROL",
        nsni(kVK_Function): @"FN",
        nsni(kVK_Delete): @"DELETE",
        nsni(kVK_CapsLock): @"CAPSLOCK",
        nsni(kVK_Help): @"HELP",
        nsni(kVK_Home): @"HOME",
        nsni(kVK_PageUp): @"PAGEUP",
        nsni(kVK_PageDown): @"PAGEDOWN",
        nsni(kVK_End): @"END",
        nsni(kVK_RightArrow): @"RIGHT_ARROW",
        nsni(kVK_LeftArrow): @"LEFT_ARROW",
        nsni(kVK_UpArrow): @"UP_ARROW",
        nsni(kVK_DownArrow): @"DOWN_ARROW",
        nsni(kVK_F1): @"F1",
        nsni(kVK_F2): @"F2",
        nsni(kVK_F3): @"F3",
        nsni(kVK_F4): @"F4",
        nsni(kVK_F5): @"F5",
        nsni(kVK_F6): @"F6",
        nsni(kVK_F7): @"F7",
        nsni(kVK_F8): @"F8",
        nsni(kVK_F9): @"F9",
        nsni(kVK_F10): @"F10",
        nsni(kVK_F11): @"F11",
        nsni(kVK_F12): @"F12",
        nsni(kVK_F13): @"F13",
        nsni(kVK_F14): @"F14",
        nsni(kVK_F15): @"F15",
        nsni(kVK_F16): @"F16",
        nsni(kVK_F17): @"F17",
        nsni(kVK_F18): @"F18",
        nsni(kVK_F19): @"F19",
        nsni(kVK_F20): @"F20"
    };
}

NSString* stringForPrintable(uint16_t keyCode) {
    TISInputSourceRef currentKeyboard = TISCopyCurrentKeyboardInputSource();
    CFDataRef layoutData =
        TISGetInputSourceProperty(currentKeyboard,
                                  kTISPropertyUnicodeKeyLayoutData);
    const UCKeyboardLayout *keyboardLayout =
        (const UCKeyboardLayout *)CFDataGetBytePtr(layoutData);
    
    UInt32 keysDown = 0;
    UniChar chars[4];
    UniCharCount realLength;
    
    OSStatus status =
        UCKeyTranslate(keyboardLayout,
                       keyCode,
                       kUCKeyActionDisplay,
                       0,
                       LMGetKbdType(),
                       kUCKeyTranslateNoDeadKeysBit,
                       &keysDown,
                       sizeof(chars) / sizeof(chars[0]),
                       &realLength,
                       chars);
    CFRelease(currentKeyboard);
    if (status == noErr && realLength != 0) {
        return [NSString stringWithCharacters: chars length: realLength];
    }
    
    return nil;
}

NSString* __nullable stringFromKeyCode(uint16_t keyCode) {
    if (nonPritableKeys == nil) {
        initialize();
    }
    
    NSString* str = [nonPritableKeys objectForKey: nsni(keyCode)];
    if (str == nil) {
        str = stringForPrintable(keyCode);
    }
    
    return str;
}
