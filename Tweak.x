/*
 * FileProviderSandboxFix
 * Author: FA8FKWV
 *
 * Fixes PlugInKit crash ("plug-in has invalid sandbox or container: error 45 path ?")
 * in com.apple.UIKit.fileprovider.default on iOS 9.3.5 with Phoenix jailbreak.
 */

#import <Foundation/Foundation.h>
#import <dlfcn.h>
#import <errno.h>
#import <string.h>
#import <sys/stat.h>
#import <substrate.h>

static const char *kFallbackContainerPath = "/var/mobile/Library/Caches/com.apple.UIKit.fileprovider.default";

static int (*orig_sandbox_container_path_for_pid)(pid_t pid, char *buffer, size_t bufsize);

static int hooked_sandbox_container_path_for_pid(pid_t pid, char *buffer, size_t bufsize) {
    int ret = orig_sandbox_container_path_for_pid ? orig_sandbox_container_path_for_pid(pid, buffer, bufsize) : -1;
    if (ret != 0 && (errno == ENOTSUP || errno == 45)) {
        mkdir(kFallbackContainerPath, 0755);
        if (buffer && bufsize > 0) {
            strlcpy(buffer, kFallbackContainerPath, bufsize);
        }
        errno = 0;
        return 0;
    }
    return ret;
}

%ctor {
    void *sym = dlsym(RTLD_DEFAULT, "sandbox_container_path_for_pid");
    if (sym) {
        MSHookFunction(sym,
                       (void *)hooked_sandbox_container_path_for_pid,
                       (void **)&orig_sandbox_container_path_for_pid);
    }
}
