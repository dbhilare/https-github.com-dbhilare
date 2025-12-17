package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformExample(t *testing.T) {

	terraformOptions := &terraform.Options{
		TerraformDir: "..",
	}

	// Deploy
	terraform.InitAndApply(t, terraformOptions)

	// Output verification (example)
	output := terraform.Output(t, terraformOptions, "resource_group_name")
	assert.Equal(t, "my-rg", output)

	// Destroy afterwards
	defer terraform.Destroy(t, terraformOptions)
}
