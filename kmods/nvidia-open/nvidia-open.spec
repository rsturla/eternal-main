Name:           nvidia-addons
Version:        0.4
Release:        1%{?dist}
Summary:        Additional files for nvidia driver support

License:        MIT
URL:            https://github.com/rsturla/eternal-linux/akmods/nvidia

BuildArch:      noarch
Supplements:    mokutil policycoreutils

Source0:        negativo17-fedora-nvidia.repo
Source1:        public_key.der
Source2:        nvidia-container-toolkit.repo
Source3:        nvidia-container.pp
Source4:        eternal-nvctk-cdi.service
Source5:        01-eternal-nvctk-cdi.preset

%description
Adds various runtime files for nvidia support. These include a key for importing with mokutil to enable secure boot for nvidia kernel modules

%prep
%setup -q -c -T


%build
install -Dm0644 %{SOURCE0} %{buildroot}%{_datadir}/eternal-linux/%{_sysconfdir}/yum.repos.d/negativo17-fedora-nvidia.repo
install -Dm0644 %{SOURCE1} %{buildroot}%{_datadir}/eternal-linux/%{_sysconfdir}/pki/akmods/certs/eternal-akmods.der
install -Dm0644 %{SOURCE2} %{buildroot}%{_datadir}/eternal-linux/%{_sysconfdir}/yum.repos.d/nvidia-container-toolkit.repo
install -Dm0644 %{SOURCE3} %{buildroot}%{_datadir}/eternal-linux/%{_datadir}/selinux/packages/nvidia-container.pp
install -Dm0644 %{SOURCE4} %{buildroot}%{_datadir}/eternal-linux/%{_unitdir}/eternal-nvctk-cdi.service
install -Dm0644 %{SOURCE5} %{buildroot}%{_presetdir}/01-eternal-nvctk-cdi.preset

sed -i 's@enabled=1@enabled=0@g' %{buildroot}%{_datadir}/eternal-linux/%{_sysconfdir}/yum.repos.d/nvidia-container-toolkit.repo
sed -i 's@enabled=1@enabled=0@g' %{buildroot}%{_datadir}/eternal-linux/%{_sysconfdir}/yum.repos.d/negativo17-fedora-nvidia.repo

install -Dm0644 %{buildroot}%{_datadir}/eternal-linux/%{_sysconfdir}/yum.repos.d/negativo17-fedora-nvidia.repo     %{buildroot}%{_sysconfdir}/yum.repos.d/negativo17-fedora-nvidia.repo
install -Dm0644 %{buildroot}%{_datadir}/eternal-linux/%{_sysconfdir}/pki/akmods/certs/eternal-akmods.der           %{buildroot}%{_sysconfdir}/pki/akmods/certs/eternal-akmods.der
install -Dm0644 %{buildroot}%{_datadir}/eternal-linux/%{_sysconfdir}/yum.repos.d/nvidia-container-toolkit.repo     %{buildroot}%{_sysconfdir}/yum.repos.d/nvidia-container-toolkit.repo
install -Dm0644 %{buildroot}%{_datadir}/eternal-linux/%{_datadir}/selinux/packages/nvidia-container.pp             %{buildroot}%{_datadir}/selinux/packages/nvidia-container.pp
install -Dm0644 %{buildroot}%{_datadir}/eternal-linux/%{_unitdir}/eternal-nvctk-cdi.service                        %{buildroot}%{_unitdir}/eternal-nvctk-cdi.service

%files
%attr(0644,root,root) %{_datadir}/eternal-linux/%{_sysconfdir}/yum.repos.d/negativo17-fedora-nvidia.repo
%attr(0644,root,root) %{_datadir}/eternal-linux/%{_sysconfdir}/pki/akmods/certs/eternal-akmods.der
%attr(0644,root,root) %{_datadir}/eternal-linux/%{_sysconfdir}/yum.repos.d/nvidia-container-toolkit.repo
%attr(0644,root,root) %{_datadir}/eternal-linux/%{_datadir}/selinux/packages/nvidia-container.pp
%attr(0644,root,root) %{_datadir}/eternal-linux/%{_unitdir}/eternal-nvctk-cdi.service
%attr(0644,root,root) %{_sysconfdir}/yum.repos.d/negativo17-fedora-nvidia.repo
%attr(0644,root,root) %{_sysconfdir}/pki/akmods/certs/eternal-akmods.der
%attr(0644,root,root) %{_sysconfdir}/yum.repos.d/nvidia-container-toolkit.repo
%attr(0644,root,root) %{_datadir}/selinux/packages/nvidia-container.pp
%attr(0644,root,root) %{_unitdir}/eternal-nvctk-cdi.service
%attr(0644,root,root) %{_presetdir}/01-eternal-nvctk-cdi.preset

%changelog
* Fri Jun 21 2024 Robert Sturla <robertsturla@outlook.com>
- switch to Negativo17

* Mon Dec 11 2023 Robert Sturla <robertsturla@outlook.com>
- add eternal-nvctk-cdi service to autogenerate Nvidia CDI device files

* Sat May 27 2023 Robert Sturla <robertsturla@outlook.com>
- Initial build
