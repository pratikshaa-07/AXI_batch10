class passive_agent extends uvm_agent;
  passive_monitor mon;

  `uvm_component_utils(passive_agent)

  function new(string name="",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon=passive_monitor::type_id::create("mon",this);
  endfunction
  
endclass
