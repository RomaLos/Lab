Name:           count-files
Version:        1.0
Release:        1%{?dist}
Summary:        Script to count files, directories and links in /etc

License:        MIT
URL:            https://github.com/RomaLos/Lab.git
Source0:        %{name}-%{version}.tar.gz

BuildArch:      noarch
Requires:       bash

%description
A Bash script that counts the number of regular files, directories, 
and symbolic links in the /etc directory.

%prep
%setup -q

%build
# Nothing to build

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_bindir}
install -m 755 count_files.sh $RPM_BUILD_ROOT%{_bindir}/count-files

%files
%{_bindir}/count-files

%changelog
* Sat Dec 14 2024 Student <student@example.com> - 1.0-1
- Initial package
