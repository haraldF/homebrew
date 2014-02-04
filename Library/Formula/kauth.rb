require "formula"

class Kauth < Formula
  homepage "http://www.kde.org/"
  url "http://download.kde.org/unstable/frameworks/4.95.0/kauth-4.95.0.tar.xz"

  head 'git://anongit.kde.org/kauth.git'

  depends_on "cmake" => :build
  depends_on "extra-cmake-modules" => :build
  depends_on "qt5"
  depends_on "kcoreaddons"

  def patches
    DATA
  end

  def install
    args = std_cmake_args
    args << "-DCMAKE_PREFIX_PATH=\"#{Formula.factory('qt5').opt_prefix};#{Formula.factory('extra-cmake-modules').opt_prefix}\""

    system "cmake", ".", *args
    system "make", "install"
  end
end

__END__
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 0709430..7502adb 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -56,7 +56,7 @@ if (NOT "${KAUTH_BACKEND_NAME}" STREQUAL "FAKE")
     add_executable(KF5::kauth-policy-gen ALIAS kauth-policy-gen)
 
     # KAUTH_POLICY_GEN_LIBRARIES has been generated from ConfigureChecks.cmake
-    target_link_libraries( kauth-policy-gen PRIVATE ${KAUTH_POLICY_GEN_LIBRARIES} )
+    target_link_libraries( kauth-policy-gen PRIVATE ${KAUTH_POLICY_GEN_LIBRARIES})
 
     install( TARGETS kauth-policy-gen EXPORT KF5AuthTargets DESTINATION ${LIBEXEC_INSTALL_DIR})
 endif ()
diff --git a/src/ConfigureChecks.cmake b/src/ConfigureChecks.cmake
index cf54815..eeb4ddd 100644
--- a/src/ConfigureChecks.cmake
+++ b/src/ConfigureChecks.cmake
@@ -124,7 +124,7 @@ if(KAUTH_BACKEND_NAME STREQUAL "OSX")
         backends/mac/AuthServicesBackend.cpp
     )
 
-    set(KAUTH_BACKEND_LIBS ${SECURITY_LIBRARY})
+    set(KAUTH_BACKEND_LIBS ${SECURITY_LIBRARY} Qt5::Core)
 elseif(KAUTH_BACKEND_NAME STREQUAL "POLKITQT")
 
     message(STATUS "Building PolkitQt KAuth backend")
@@ -173,7 +173,7 @@ set(KAUTH_POLICY_GEN_LIBRARIES)
 if(KAUTH_BACKEND_NAME STREQUAL "OSX")
    set(KAUTH_POLICY_GEN_SRCS ${KAUTH_POLICY_GEN_SRCS}
        backends/mac/kauth-policy-gen-mac.cpp)
-   set(KAUTH_POLICY_GEN_LIBRARIES ${KAUTH_POLICY_GEN_LIBRARIES} ${CORE_FOUNDATION_LIBRARY} ${SECURITY_LIBRARY})
+   set(KAUTH_POLICY_GEN_LIBRARIES ${KAUTH_POLICY_GEN_LIBRARIES} ${CORE_FOUNDATION_LIBRARY} ${SECURITY_LIBRARY} Qt5::Core)
 elseif(KAUTH_BACKEND_NAME STREQUAL "POLKITQT")
    set(KAUTH_POLICY_GEN_SRCS ${KAUTH_POLICY_GEN_SRCS}
        backends/policykit/kauth-policy-gen-polkit.cpp )
diff --git a/src/backends/mac/AuthServicesBackend.cpp b/src/backends/mac/AuthServicesBackend.cpp
index 25adc1a..e832bfe 100644
--- a/src/backends/mac/AuthServicesBackend.cpp
+++ b/src/backends/mac/AuthServicesBackend.cpp
@@ -58,8 +58,10 @@ Action::AuthStatus AuthServicesBackend::authorizeAction(const QString &action)
 
 Action::AuthStatus AuthServicesBackend::actionStatus(const QString &action)
 {
+    const QByteArray actionName = action.toUtf8();
+
     AuthorizationItem item;
-    item.name = action.toUtf8();
+    item.name = actionName.constData();
     item.valueLength = 0;
     item.value = NULL;
     item.flags = 0;
@@ -105,8 +107,10 @@ bool AuthServicesBackend::isCallerAuthorized(const QString &action, QByteArray c
         return false;
     }
 
+    const QByteArray actionName = action.toUtf8();
+
     AuthorizationItem item;
-    item.name = action.toUtf8();
+    item.name = actionName.constData();
     item.valueLength = 0;
     item.value = NULL;
     item.flags = 0;
@@ -128,7 +132,7 @@ bool AuthServicesBackend::isCallerAuthorized(const QString &action, QByteArray c
 
 bool AuthServicesBackend::actionExists(const QString &action)
 {
-    OSStatus exists = AuthorizationRightGet(action.toUtf8(), NULL);
+    OSStatus exists = AuthorizationRightGet(action.toUtf8().constData(), NULL);
 
     return exists == errAuthorizationSuccess;
 }
diff --git a/src/backends/mac/kauth-policy-gen-mac.cpp b/src/backends/mac/kauth-policy-gen-mac.cpp
index 13b6241..b8d3cfc 100644
--- a/src/backends/mac/kauth-policy-gen-mac.cpp
+++ b/src/backends/mac/kauth-policy-gen-mac.cpp
@@ -17,7 +17,7 @@
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA .
 */
 
-#include <auth/policy-gen/policy-gen.h>
+#include "../../policy-gen/policy-gen.h"
 
 #include <iostream>
 #include <Security/Security.h>
@@ -33,7 +33,7 @@ void output(QList<Action> actions, QHash<QString, QString> domain)
 
     foreach (const Action &action, actions) {
 
-        err = AuthorizationRightGet(action.name.toLatin1(), NULL);
+        err = AuthorizationRightGet(action.name.toLatin1().constData(), NULL);
 
         if (err == errAuthorizationDenied) {
 
@@ -49,10 +49,10 @@ void output(QList<Action> actions, QHash<QString, QString> domain)
                 rule = QString::fromLatin1(kAuthorizationRuleAuthenticateAsAdmin);
             }
 
-            CFStringRef cfRule = CFStringCreateWithCString(NULL, rule.toLatin1(), kCFStringEncodingASCII);
-            CFStringRef cfPrompt = CFStringCreateWithCString(NULL, action.descriptions.value(QLatin1String("en")).toLatin1(), kCFStringEncodingASCII);
+            CFStringRef cfRule = CFStringCreateWithCString(NULL, rule.toLatin1().constData(), kCFStringEncodingASCII);
+            CFStringRef cfPrompt = CFStringCreateWithCString(NULL, action.descriptions.value(QLatin1String("en")).toLatin1().constData(), kCFStringEncodingASCII);
 
-            err = AuthorizationRightSet(auth, action.name.toLatin1(), cfRule, cfPrompt, NULL, NULL);
+            err = AuthorizationRightSet(auth, action.name.toLatin1().constData(), cfRule, cfPrompt, NULL, NULL);
             if (err != noErr) {
                 cerr << "You don't have the right to edit the security database (try to run cmake with sudo): " << err << endl;
                 exit(1);
diff --git a/src/policy-gen/policy-gen.cpp b/src/policy-gen/policy-gen.cpp
index f93f667..99bb085 100644
--- a/src/policy-gen/policy-gen.cpp
+++ b/src/policy-gen/policy-gen.cpp
@@ -28,6 +28,7 @@
 #include <QDebug>
 
 #include <cstdio>
+#include <errno.h>
 
 using namespace std;
 
