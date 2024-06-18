//
//  iPhoneMirroringInject.m
//  iPhoneMirroringInject
//
//  Created by Kyle on 2024/6/18.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <AppKit/AppKit.h>

__attribute__((constructor))
static void iPhoneMirroringInject(int argc, const char **argv) {
    // "iPhone Mirroring.AppDelegate" Swift class's mangled name in ObjC runtime
    Class appDelegate = NSClassFromString(@"_TtC16iPhone_Mirroring11AppDelegate");
    NSLog(@"[+] AppDelegate: %@", appDelegate);
    SEL selector = NSSelectorFromString(@"applicationWillFinishLaunching:");

    class_replaceMethod(appDelegate, selector, imp_implementationWithBlock(^(id _self, NSApplication *application) {
        NSLog(@"[+] applicationWillFinishLaunching: %@", application);
    }), "v@:@");
}
