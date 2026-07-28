//--------------------------------------------------------------------------------------------
// Package: cpu_tb_pkg
// NEW FILE. Bundles every tb/ class into one package, in dependency order,
// matching the vendor's own axi4_master_pkg.sv / axi4_slave_pkg.sv convention.
// Needs axi4_globals_pkg and axi4_slave_pkg compiled/imported before this.
//--------------------------------------------------------------------------------------------
package tb_pkg;

  import uvm_pkg::*;
  `include "uvm_macros.svh"
  import axi4_globals_pkg::*;
  import axi4_slave_pkg::*;

  `include "tb_seq_item.sv"

  `include "tb_active_agent/sequencer.sv"
  `include "tb_active_agent/driver.sv"
  `include "tb_active_agent/active_monitor.sv"
  `include "tb_active_agent/active_agent.sv"

  `include "tb_passive_agent/passive_agent.sv"
  `incluse "tb_passive_agent/passive_monitor.sv"

  `include "env/scoreboard.sv"
  `include "env/environment.sv"
  `include "env/axi4_vip_env.sv"
  `include "env/top_env.sv"

  `include "vseq/top_vseq.sv"

  `include "test/base_test.sv"

endpackage : cpu_tb_pkg
