$jumboping=ping 192.162.1.123 -l 8000 -f -S 192.162.1.122
Write-Output $jumboping

  #- name: Check Jumbo Frame results
    #delegate_to: 192.162.1.121
    #vars:
      #jumbocheck: "{{ jumboresults }}"
    #ansible.builtin.debug:
      #msg: "{{ jumboresults }}"
    #when:
      #- ansible_facts['os_family'] == "Windows"
      #- "'E0:1A:EA:' in jumbocheck" # TODO: Edit these tests to include EC:CD:6D
      #- "'(0%' in jumbocheck"
    #with_items: "{{ jumboresults }}"

